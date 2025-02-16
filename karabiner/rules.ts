import fs from 'fs';
import { KarabinerRules } from './types';
import { createHyperSubLayers, app, open, rectangle, shell } from './utils';

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: 'Hyper Key (⌃⌥⇧⌘)',
    manipulators: [
      {
        description: 'Caps Lock -> Hyper Key',
        from: {
          key_code: 'caps_lock',
          modifiers: {
            optional: ['any'],
          },
        },
        to: [
          {
            set_variable: {
              name: 'hyper',
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: 'hyper',
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: 'caps_lock',
          },
        ],
        type: 'basic',
      },
      //      {
      //        type: "basic",
      //        description: "Disable CMD + Tab to force Hyper Key usage",
      //        from: {
      //          key_code: "tab",
      //          modifiers: {
      //            mandatory: ["left_command"],
      //          },
      //        },
      //        to: [
      //          {
      //            key_code: "tab",
      //          },
      //        ],
      //      },
    ],
  },
  ...createHyperSubLayers({
    // b = "B"rowse
    b: {
      t: open('https://x.com'),
      g: open('https://github.com'),
    },
    // o = "O"pen applications
    o: {
      c: app('Google Chrome'),
      g: app('Ghostty'),
      f: app('Finder'),
      s: app('Spotify'),
      // w: open('WhatsApp'),
      // d: app('Discord'),
      // s: app('Slack'),
    },
    // w = "W"indow via rectangle.app
    w: {
      semicolon: {
        description: 'Window: Hide',
        to: [
          {
            key_code: 'h',
            modifiers: ['right_command'],
          },
        ],
      },
      y: rectangle('previous-display'),
      o: rectangle('next-display'),
      k: rectangle('top-half'),
      j: rectangle('bottom-half'),
      h: rectangle('left-half'),
      l: rectangle('right-half'),
      f: rectangle('maximize'),
      u: {
        description: 'Window: Previous Tab',
        to: [
          {
            key_code: 'tab',
            modifiers: ['right_control', 'right_shift'],
          },
        ],
      },
      i: {
        description: 'Window: Next Tab',
        to: [
          {
            key_code: 'tab',
            modifiers: ['right_control'],
          },
        ],
      },
      n: {
        description: 'Window: Next Window',
        to: [
          {
            key_code: 'grave_accent_and_tilde',
            modifiers: ['right_command'],
          },
        ],
      },
      b: {
        description: 'Window: Back',
        to: [
          {
            key_code: 'open_bracket',
            modifiers: ['right_command'],
          },
        ],
      },
      // Note: No literal connection. Both f and n are already taken.
      m: {
        description: 'Window: Forward',
        to: [
          {
            key_code: 'close_bracket',
            modifiers: ['right_command'],
          },
        ],
      },
    },

    // s = "System"
    s: {
      u: {
        to: [
          {
            key_code: 'volume_increment',
          },
        ],
      },
      j: {
        to: [
          {
            key_code: 'volume_decrement',
          },
        ],
      },
      i: {
        to: [
          {
            key_code: 'display_brightness_increment',
          },
        ],
      },
      k: {
        to: [
          {
            key_code: 'display_brightness_decrement',
          },
        ],
      },
      l: {
        to: [
          {
            key_code: 'q',
            modifiers: ['right_control', 'right_command'],
          },
        ],
      },
      p: {
        to: [
          {
            key_code: 'play_or_pause',
          },
        ],
      },
      semicolon: {
        to: [
          {
            key_code: 'fastforward',
          },
        ],
      },
      // 'v'oice
      v: {
        to: [
          {
            key_code: 'spacebar',
            modifiers: ['left_option'],
          },
        ],
      },
    },

    // v = mo"v"e which isn't "m" because we want it to be on the left hand
    // so that hjkl work like they do in vim
    v: {
      h: {
        to: [{ key_code: 'left_arrow' }],
      },
      j: {
        to: [{ key_code: 'down_arrow' }],
      },
      k: {
        to: [{ key_code: 'up_arrow' }],
      },
      l: {
        to: [{ key_code: 'right_arrow' }],
      },
      u: {
        to: [{ key_code: 'page_down' }],
      },
      i: {
        to: [{ key_code: 'page_up' }],
      },
    },

    // c = Musi"c" which isn't "m" because we want it to be on the left hand
    c: {
      p: {
        to: [{ key_code: 'play_or_pause' }],
      },
      n: {
        to: [{ key_code: 'fastforward' }],
      },
      b: {
        to: [{ key_code: 'rewind' }],
      },
    },
  }),
];

fs.writeFileSync(
  'karabiner.json',
  JSON.stringify(
    {
      global: {
        ask_for_confirmation_before_quitting: true,
        check_for_updates_on_startup: false,
        show_in_menu_bar: false,
        show_profile_name_in_menu_bar: false,
        unsafe_ui: false,
      },
      profiles: [
        {
          name: 'Default',
          virtual_hid_keyboard: { keyboard_type_v2: 'ansi' },
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2,
  ),
);
