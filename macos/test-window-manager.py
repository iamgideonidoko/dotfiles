#!/usr/bin/env python3
"""Check backup/rollback without changing the desktop or macOS preferences."""
import importlib.util
import json
from pathlib import Path
import plistlib
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('manager', Path(__file__).with_name('window-manager.py'))
manager = importlib.util.module_from_spec(spec)
spec.loader.exec_module(manager)


class WindowManagerTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        root = Path(self.temporary.name)
        for name, value in [('STATE', root), ('BACKUP', root / 'preferences.json'), ('AGENT', root / 'login.plist')]:
            patcher = patch.object(manager, name, value)
            patcher.start()
            self.addCleanup(patcher.stop)

    def snapshot(self):
        exported = subprocess.CompletedProcess([], 0, plistlib.dumps({'spans-displays': True, 'reduceMotion': False}))
        with patch.object(manager.subprocess, 'run', return_value=exported), patch.object(
            manager, 'apple', side_effect=['2', 'Built-in Retina Display', '/one.jpg', 'Mi Monitor', '/two.jpg']
        ):
            manager.snapshot()
        return json.loads(manager.BACKUP.read_text())

    def test_backup_preserves_absent_keys_and_each_display(self):
        saved = self.snapshot()
        self.assertEqual(saved['wallpapers'], [['Built-in Retina Display', '/one.jpg'], ['Mi Monitor', '/two.jpg']])
        self.assertEqual(saved['preferences'][0][-1], True)
        self.assertIsNone(saved['preferences'][2][-1])
        original = manager.BACKUP.read_bytes()
        with patch.object(manager, 'apple', side_effect=AssertionError('snapshot must not repeat')):
            manager.snapshot()
        self.assertEqual(manager.BACKUP.read_bytes(), original)

    def test_rollback_restores_backup_and_disables_shortcuts(self):
        saved = self.snapshot()
        manager.AGENT.write_text('agent')
        with patch.object(manager, 'quit_app') as quit_app, patch.object(manager, 'login_items'), patch.object(
            manager, 'set_hyper'
        ) as hyper, patch.object(manager, 'write_preference') as preference, patch.object(
            manager, 'wallpaper'
        ) as wallpaper, patch.object(manager, 'run'), patch.object(manager.subprocess, 'run'):
            manager.rollback()
        quit_app.assert_called_once_with('OmniWM')
        hyper.assert_called_once_with(False)
        self.assertEqual(preference.call_count, len(saved['preferences']))
        wallpaper.assert_any_call('/one.jpg', 'Built-in Retina Display')
        wallpaper.assert_any_call('/two.jpg', 'Mi Monitor')
        self.assertFalse(manager.BACKUP.exists())
        self.assertFalse(manager.AGENT.exists())

    def test_failed_restore_keeps_backup(self):
        self.snapshot()
        with patch.object(manager, 'quit_app'), patch.object(manager, 'login_items'), patch.object(
            manager, 'set_hyper'
        ), patch.object(manager, 'write_preference', side_effect=RuntimeError('cannot restore')), patch.object(
            manager.subprocess, 'run'
        ):
            with self.assertRaises(RuntimeError):
                manager.rollback()
        self.assertTrue(manager.BACKUP.exists())

    def test_absent_preference_is_deleted_only_when_present(self):
        with patch.object(manager.subprocess, 'run', return_value=subprocess.CompletedProcess([], 1)), patch.object(manager, 'run') as run:
            manager.write_preference('domain', 'key', 'bool', None)
            run.assert_not_called()
        with patch.object(manager.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, '1')), patch.object(manager, 'run') as run:
            manager.write_preference('domain', 'key', 'bool', None)
            run.assert_called_once_with('defaults', 'delete', 'domain', 'key')

    def test_unchanged_accessibility_setting_needs_no_admin_write(self):
        with patch.object(manager.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, '0')), patch.object(manager, 'run') as run:
            manager.write_preference('com.apple.universalaccess', 'reduceMotion', 'bool', False)
            run.assert_not_called()


if __name__ == '__main__':
    unittest.main()
