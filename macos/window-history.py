#!/usr/bin/env python3
"""Remember observed OmniWM focus independently of its previous-window command."""
import json
import os
from pathlib import Path
import subprocess
import sys

STATE = Path.home() / '.local/state/dotfiles/window-manager/focus.json'


def remember(history, window_id):
    return [window_id] + [item for item in history if item != window_id][:63]


def previous(history, windows):
    current = next((w for w in windows if w.get('isFocused')), None)
    if current is None:
        raise RuntimeError('No managed window has focus.')
    def app(window):
        return window.get('app', {}).get('bundleId') or window['pid']
    other_apps = {w['id'] for w in windows if app(w) != app(current)}
    return next((item for item in history if item in other_apps), None)


def load():
    try:
        return json.loads(STATE.read_text())
    except FileNotFoundError:
        return []


def watch():
    history = load()
    STATE.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    with subprocess.Popen(
        ['omniwmctl', 'subscribe', 'focus', '--reconnect', '--format', 'ndjson'],
        stdout=subprocess.PIPE, text=True,
    ) as process:
        try:
            for line in process.stdout:
                event = json.loads(line)
                if event.get('kind') != 'event' or event.get('channel') != 'focus':
                    continue
                window = event.get('result', {}).get('payload', {}).get('window')
                if not window or history[:1] == [window['id']]:
                    continue
                history = remember(history, window['id'])
                temporary = STATE.with_suffix('.tmp')
                temporary.write_text(json.dumps(history) + '\n')
                temporary.replace(STATE)
        finally:
            process.terminate()
        raise RuntimeError('OmniWM focus subscription ended.')


def main():
    os.environ['PATH'] = '/opt/homebrew/bin:/usr/local/bin:' + os.environ.get('PATH', '')
    if sys.argv[1:] == ['watch']:
        watch()
    elif sys.argv[1:] == ['previous']:
        response = json.loads(subprocess.check_output(['omniwmctl', 'query', 'windows', '--json']))
        if not response.get('ok') or response.get('result', {}).get('kind') != 'windows':
            raise RuntimeError('OmniWM window query failed.')
        history = load()
        windows = response['result']['payload']['windows']
        target = previous(history, windows)
        if target is None:
            raise RuntimeError('No previous app recorded; focus windows from two apps with the focus-history agent running.')
        subprocess.run(['omniwmctl', 'window', 'navigate', target], check=True)
    else:
        raise RuntimeError('Usage: dotfiles-window-history {watch|previous}')


if __name__ == '__main__':
    try:
        main()
    except (RuntimeError, OSError, ValueError, subprocess.CalledProcessError) as error:
        sys.exit(str(error))
