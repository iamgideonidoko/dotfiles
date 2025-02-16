# Karabiner Elements configuration

## Installation

Setup `dotfiles` as instructed (brew install, symlink, ...), restart Karabiner Elements and finish up setup (permission, keyboard pick...) if you haven't yet.

## Development

Install the dependencies:

```
yarn install
```

Build the `karabiner.json` from the `rules.ts`.

```
yarn run build
```

Watch the TypeScript files and rebuilds whenever they change.

```
yarn run watch
```
