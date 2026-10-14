#!/usr/bin/env python3
"""Check global window history, including the two-display Chrome regression."""
import importlib.util
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('history', Path(__file__).with_name('window-history.py'))
history = importlib.util.module_from_spec(spec)
spec.loader.exec_module(history)


class HistoryTest(unittest.TestCase):
    def test_cross_display_same_app_and_repeated_toggle(self):
        windows = [
            {'id': 'ghostty-3', 'pid': 1, 'isFocused': True},
            {'id': 'chrome-9', 'pid': 2},
            {'id': 'chrome-10', 'pid': 2},
        ]
        recent = []
        for window in ('chrome-9', 'ghostty-3', 'chrome-10', 'ghostty-3'):
            recent = history.remember(recent, window)
        self.assertEqual(history.previous(recent, windows), 'chrome-10')
        recent = history.remember(recent, 'chrome-10')
        windows[0]['isFocused'] = False
        windows[2]['isFocused'] = True
        self.assertEqual(history.previous(recent, windows), 'ghostty-3')

    def test_skips_same_app_even_with_distinct_processes(self):
        windows = [
            {'id': 'chrome-10', 'pid': 2, 'app': {'bundleId': 'chrome'}, 'isFocused': True},
            {'id': 'chrome-9', 'pid': 3, 'app': {'bundleId': 'chrome'}},
            {'id': 'ghostty-3', 'pid': 1, 'app': {'bundleId': 'ghostty'}},
        ]
        self.assertEqual(history.previous(['chrome-10', 'chrome-9', 'ghostty-3'], windows), 'ghostty-3')
        self.assertIsNone(history.previous(['chrome-10', 'chrome-9'], windows))

    def test_closed_windows_are_skipped_and_history_is_bounded(self):
        self.assertEqual(history.previous(['current', 'closed', 'floating'], [
            {'id': 'current', 'pid': 1, 'isFocused': True}, {'id': 'floating', 'pid': 2, 'mode': 'floating'},
        ]), 'floating')
        self.assertEqual(len(history.remember(list(map(str, range(100))), 'new')), 64)
        self.assertEqual(history.remember(['a', 'b'], 'b'), ['b', 'a'])

    def test_missing_focus_does_not_guess(self):
        with self.assertRaises(RuntimeError):
            history.previous(['a'], [{'id': 'a'}])
        self.assertIsNone(history.previous(['a'], [{'id': 'a', 'pid': 1, 'isFocused': True}]))


if __name__ == '__main__':
    unittest.main()
