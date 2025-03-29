import fs from 'fs';
import { KarabinerRules } from './types';
import { createHyperSubLayers, app, open, rectangle, hammerspoon, shell } from './utils';

const mouseSpeed = 1536,
  mouseSpeedFast = mouseSpeed * 4;

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
            repeat: false,
          },
          {
            ...hammerspoon('toggleCapsLock', { repeat: false }).to[0], // Toggle Caps Lock normally
          },
        ],
        parameters: {
          'basic.to_if_alone_timeout_milliseconds': 200,
        },
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
      x: open('https://x.com'), // "x".com
      g: open('https://github.com'), // "g"ithub.com
      i: open('https://mail.google.com'), // mai"i"l.google.com
      d: open('https://app.daily.dev'), // "d"aily.dev
      f: open('https://figma.com'), // "f"igma.com
      c: open('https://www.canva.com/?continue_in_browser=true'), // "c"anva.com
      t: open('https://www.capcut.com'), // capcu"t".com
    },
    // o = "O"pen applications
    o: {
      // Alternate app
      a: {
        to: [
          {
            key_code: 'tab',
            modifiers: ['right_command'],
            repeat: false,
          },
          {
            key_code: 'vk_none',
            halt: true,
          },
        ],
      },
      c: app('Google Chrome'), // Google "c"hrome
      g: app('Ghostty'), // "g"hostty
      f: app('Finder'), // "f"inder
      s: app('Spotify'), // "s"potify
      d: app('Dictionary'), // "d"ictionary
      n: app('Notes'), // "n"otes
      k: app('Slack'), // Slac"k"
      w: app('Whatsapp'), // "w"hatsapp
      r: app('Discord'), // Disco"r"d
      i: app('iPhone Mirroring'), // "i"phone Mirroring
      x: app('Xcode-16.2.0'), // "x"code
      t: app('Android Studio'), // Android S"t"udio
      comma: hammerspoon('openAndroidEmulator', { repeat: false }), // Android Studio's Android Emulator
      period: app('Simulator'), // Xcode's iOS Simulator
      spacebar: app('ChatGPT'), // Xcode's iOS Simulator
      // Chrome apps (chrome://apps)
      y: app('YouTube'), // "y"ouTube
      m: app('YouTube Music'), // YouTube "m"usic
      p: app('Photopea'), // "p"hotopea
      v: app('Google Drive'), // Google D"r"ive
    },
    // e = Mous"e" (I need a better cursor actuator but for now i'm stuck with using Karabiner Elements and Scoot)
    e: {
      j: [
        {
          to: [{ mouse_key: { y: mouseSpeedFast } }],
          from: {
            modifiers: {
              mandatory: ['left_command'],
            },
          },
        },
        {
          to: [{ mouse_key: { y: mouseSpeed } }],
        },
      ],
      k: [
        {
          to: [{ mouse_key: { y: -mouseSpeedFast } }],
          from: {
            modifiers: {
              mandatory: ['left_command'],
            },
          },
        },
        {
          to: [{ mouse_key: { y: -mouseSpeed } }],
        },
      ],
      h: [
        {
          to: [{ mouse_key: { x: -mouseSpeedFast } }],
          from: {
            modifiers: {
              mandatory: ['left_command'],
            },
          },
        },
        {
          to: [{ mouse_key: { x: -mouseSpeed } }],
        },
      ],
      l: [
        {
          to: [{ mouse_key: { x: mouseSpeedFast } }],
          from: {
            modifiers: {
              mandatory: ['left_command'],
            },
          },
        },
        {
          to: [{ mouse_key: { x: mouseSpeed } }],
        },
      ],
      return_or_enter: {
        to: [{ pointing_button: 'button1' }],
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
        to: [{ mouse_key: { horizontal_wheel: 32 } }],
      },
      period: {
        to: [{ mouse_key: { horizontal_wheel: -32 } }],
      },
      /**
       * Ensure that Scoot has been given the necessary permissions to control the mouse
       * Also, preferably switch from Emacs to Vim mode ;)
       * Also, ensure it starts on login :)
       */
      // Scoot's grid-based navigation of cursor
      slash: {
        to: [{ key_code: 'k', modifiers: ['right_command', 'right_shift'] }],
      },
      // Scoot's element-based navigation of cursor
      f: {
        to: [{ key_code: 'j', modifiers: ['right_command', 'right_shift'] }],
      },
      p: {
        to: [{ key_code: 'open_bracket', modifiers: ['right_command'] }],
      },
      n: {
        to: [{ key_code: 'close_bracket', modifiers: ['right_command'] }],
      },
    },
    // w = "W"indow via rectangle.app
    w: {
      e: {
        to: [{ key_code: 'escape' }, { key_code: 'escape', repeat: false }],
      },
      k: rectangle('top-half'),
      j: rectangle('bottom-half'),
      h: rectangle('left-half'),
      l: rectangle('right-half'),
      return_or_enter: rectangle('maximize'),
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

    // s = "S"ystem
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
      c: {
        to: [
          {
            key_code: 'c',
            modifiers: ['right_shift', 'right_command'],
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
      spacebar: {
        to: [{ key_code: 'play_or_pause' }],
      },
      k: {
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
