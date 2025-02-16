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
            set_variable: {
              name: 'hyper',
              value: 0,
            },
          },
          {
            key_code: 'escape',
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
      d: app('Dictionary'),
      n: app('Notes'),
      // w: open('WhatsApp'),
      // d: app('Discord'),
      // s: app('Slack'),
    },
    // e = Mous"e"
    e: {
      j: {
        to: [{ mouse_key: { y: 1536 } }],
      },
      k: {
        to: [{ mouse_key: { y: -1536 } }],
      },
      h: {
        to: [{ mouse_key: { x: -1536 } }],
      },
      l: {
        to: [{ mouse_key: { x: 1536 } }],
      },
      spacebar: {
        to: [{ pointing_button: 'button1' }],
      },
      i: {
        to: [{ mouse_key: { vertical_wheel: -32 } }],
      },
      o: {
        to: [{ mouse_key: { vertical_wheel: 32 } }],
      },
      comma: {
        to: [{ mouse_key: { horizontal_wheel: -32 } }],
      },
      period: {
        to: [{ mouse_key: { horizontal_wheel: 32 } }],
      },
    },
    // w = "W"indow via rectangle.app
    w: {
      e: {
        to: [{ key_code: 'h' }, { key_code: 'i', repeat: false }],
      },
      semicolon: {
        description: 'Window: Hide',
        to: [
          {
            key_code: 'h',
            modifiers: ['right_command'],
          },
        ],
      },
      k: rectangle('top-half'),
      j: rectangle('bottom-half'),
      h: rectangle('left-half'),
      l: rectangle('right-half'),
      f: rectangle('maximize'),
      r: rectangle('restore'),
      i: {
        description: 'Window: Previous Tab',
        to: [
          {
            key_code: 'tab',
            modifiers: ['right_control', 'right_shift'],
          },
        ],
      },
      o: {
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
    },

    // s = "System"
    s: {
      o: {
        to: [
          {
            key_code: 'volume_increment',
          },
        ],
      },
      i: {
        to: [
          {
            key_code: 'volume_decrement',
          },
        ],
      },
      k: {
        to: [
          {
            key_code: 'display_brightness_increment',
          },
        ],
      },
      j: {
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
      i: {
        to: [{ key_code: 'page_down' }],
      },
      o: {
        to: [{ key_code: 'page_up' }],
      },
    },

    // c = Musi"c" which isn't "m" because we want it to be on the left hand
    c: {
      k: {
        to: [{ key_code: 'play_or_pause' }],
      },
      l: {
        to: [{ key_code: 'fastforward' }],
      },
      j: {
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
