#!/usr/bin/env python3
"""Activate OmniWM or restore AeroSpace without editing legacy dotfiles."""
import argparse
import json
import os
from pathlib import Path
import plistlib
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent.parent
STATE = Path.home() / '.local/state/dotfiles/window-manager'
BACKUP = STATE / 'preferences.json'
AGENT = Path.home() / 'Library/LaunchAgents/com.dotfiles.omniwm.plist'
KARABINER = '/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli'
PREFERENCES = [
    ('com.apple.spaces', 'spans-displays', 'bool', False),
    ('com.apple.universalaccess', 'reduceMotion', 'bool', False),
    ('NSGlobalDomain', 'NSAutomaticWindowAnimationsEnabled', 'bool', True),
    ('NSGlobalDomain', 'NSWindowResizeTime', 'float', 0.2),
    ('NSGlobalDomain', 'NSConvolutionOverride1', 'float', 8.0),
    ('NSGlobalDomain', 'NSConvolutionOverride2', 'float', 8.0),
    ('com.apple.dock', 'expose-animation-duration', 'float', 0.2),
    ('com.apple.dock', 'launchanim', 'bool', True),
    ('com.apple.dock', 'appswitcher-animation-off', 'bool', False),
]


def run(*args, capture=False):
    return subprocess.run(args, check=True, text=True, capture_output=capture)


def apple(script, *args):
    return run('osascript', '-e', script, *args, capture=True).stdout.strip()


def login_items(remove=()):
    return apple('''on run names
      tell application "System Events"
        repeat with itemName in names
          if exists login item (itemName as text) then delete login item (itemName as text)
        end repeat
      end tell
    end run''', *remove)


def quit_app(name):
    if subprocess.run(['pgrep', '-x', name], capture_output=True).returncode:
        return
    apple('on run argv\n tell application (item 1 of argv) to quit\nend run', name)
    for _ in range(50):
        if subprocess.run(['pgrep', '-x', name], capture_output=True).returncode:
            return
        time.sleep(0.1)
    raise RuntimeError(f'{name} did not quit; close it before switching window managers')


def set_hyper(enabled):
    if Path(KARABINER).is_file():
        run(KARABINER, '--set-variables', json.dumps({'dotfiles_omniwm': int(enabled)}))


def snapshot():
    if BACKUP.exists():
        return
    saved = []
    for domain, key, kind, _ in PREFERENCES:
        exported = subprocess.run(['defaults', 'export', domain, '-'], capture_output=True)
        if exported.returncode:
            raise RuntimeError(f'Cannot back up preferences for {domain}')
        values = plistlib.loads(exported.stdout)
        saved.append([domain, key, kind, values.get(key)])
    wallpapers = []
    count = int(apple('tell application "System Events" to count desktops'))
    for index in range(1, count + 1):
        name = apple(f'tell application "System Events" to get name of desktop {index}')
        picture = apple(f'tell application "System Events" to get picture of desktop {index}')
        wallpapers.append([name, picture])
    STATE.mkdir(parents=True, exist_ok=True, mode=0o700)
    temporary = BACKUP.with_suffix('.tmp')
    temporary.write_text(json.dumps({'preferences': saved, 'wallpapers': wallpapers}, indent=2) + '\n')
    temporary.chmod(0o600)
    temporary.replace(BACKUP)


def write_preference(domain, key, kind, value):
    current = subprocess.run(['defaults', 'read', domain, key], capture_output=True, text=True)
    if current.returncode == 0 and value is not None:
        raw = current.stdout.strip()
        try:
            existing = raw.lower() in ('1', 'true', 'yes') if kind == 'bool' else float(raw)
            if existing == value:
                return
        except ValueError:
            pass
    if value is None:
        if current.returncode == 0:
            if domain == 'com.apple.universalaccess':
                run('sudo', 'defaults', 'delete', domain, key)
            else:
                run('defaults', 'delete', domain, key)
    else:
        raw = str(value).lower() if kind == 'bool' else str(value)
        if domain == 'com.apple.universalaccess':
            run('sudo', 'defaults', 'write', domain, key, '-' + kind, raw)
        else:
            run('defaults', 'write', domain, key, '-' + kind, raw)


def wallpaper(path, display=''):
    apple('''on run argv
      tell application "System Events"
        repeat with screen in desktops
          if item 2 of argv is "" or name of screen is item 2 of argv then
            set picture of screen to item 1 of argv
          end if
        end repeat
      end tell
    end run''', path, display)


def start_omniwm():
    quit_app('AeroSpace')
    set_hyper(True)
    run('open', '-a', 'OmniWM')


def activate():
    if not Path('/Applications/OmniWM.app').is_dir():
        run('brew', 'install', '--cask', 'omniwm')
    snapshot()
    saved = json.loads(BACKUP.read_text())
    # Keep the logout reminder after a partially completed activation is retried.
    changed_spaces = any(domain == 'com.apple.spaces' and key == 'spans-displays' and value is True
                         for domain, key, _, value in saved['preferences'])
    # Finish preference changes before stopping the previous desktop.
    for domain, key, kind, value in PREFERENCES:
        write_preference(domain, key, kind, value)
    wallpaper(str(ROOT / 'wallpapers/min-omarchy.jpg'))
    # Remove the OS login entry after quitting so AeroSpace cannot re-register it.
    quit_app('AeroSpace')
    login_items(('AeroSpace', 'OmniWM'))
    run('brew', 'services', 'stop', 'sketchybar')
    run('brew', 'services', 'stop', 'borders')
    for name in ('sketchybar', 'borders'):
        subprocess.run(['pkill', '-x', name], check=False)
    AGENT.parent.mkdir(parents=True, exist_ok=True)
    # A LaunchAgent makes startup reproducible without driving OmniWM's Settings UI.
    AGENT.write_bytes(plistlib.dumps({
        'Label': 'com.dotfiles.omniwm',
        'ProgramArguments': [sys.executable, str(Path(__file__).resolve()), '--login'],
        'RunAtLoad': True,
        'StandardErrorPath': str(STATE / 'login.log'),
    }))
    service = f'gui/{os.getuid()}/com.dotfiles.omniwm'
    subprocess.run(['launchctl', 'bootout', service], capture_output=True)
    run('launchctl', 'enable', service)
    run('launchctl', 'bootstrap', f'gui/{os.getuid()}', str(AGENT))
    start_omniwm()
    print('OmniWM selected. Grant Accessibility and Input Monitoring in System Settings.')
    print('Screen Recording enables Overview thumbnails and hover previews.')
    print('Disable macOS three-finger desktop swipes and four-finger Mission Control gestures to use OmniWM gestures.')
    print('Fully quit and reopen apps to apply 8-point window corners.')
    if changed_spaces:
        print('Log out and back in to enable separate display Spaces. No logout was forced.')


def rollback():
    quit_app('OmniWM')
    login_items(('OmniWM',))
    subprocess.run(['launchctl', 'bootout', f'gui/{os.getuid()}/com.dotfiles.omniwm'], capture_output=True)
    AGENT.unlink(missing_ok=True)
    set_hyper(False)
    if BACKUP.exists():
        saved = json.loads(BACKUP.read_text())
        for domain, key, kind, value in saved['preferences']:
            write_preference(domain, key, kind, value)
        for display, picture in saved['wallpapers']:
            wallpaper(picture, display)
    run('open', '-a', 'AeroSpace')
    run('brew', 'services', 'restart', 'sketchybar')
    run('brew', 'services', 'restart', 'borders')
    BACKUP.unlink(missing_ok=True)
    print('AeroSpace restored. Log out and back in if the separate Spaces setting changed.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('manager', nargs='?', choices=['omniwm', 'aerospace'], default='omniwm')
    parser.add_argument('--login', action='store_true')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    if args.dry_run:
        print(f'{args.manager}: preserve legacy configs; ' + (
            'back up preferences, stop legacy services, enable motion/Spaces, install login agent, open OmniWM'
            if args.manager == 'omniwm' else 'stop OmniWM, remove login agent, restore preferences, start AeroSpace/bar/borders'))
        return
    if sys.platform != 'darwin':
        parser.error('requires macOS')
    if args.manager == 'omniwm' and (os.uname().machine != 'arm64' or int(run('sw_vers', '-productVersion', capture=True).stdout.split('.')[0]) < 26):
        parser.error('OmniWM requires Apple Silicon and macOS 26+')
    if args.login:
        start_omniwm()
    elif args.manager == 'omniwm':
        activate()
    else:
        rollback()


if __name__ == '__main__':
    try:
        main()
    except (subprocess.CalledProcessError, RuntimeError) as error:
        print(f'Window manager switch failed: {error}. Preferences backup: {BACKUP}', file=sys.stderr)
        sys.exit(1)
