# Setup

1. Install svim (SketchyVim) on Mac OS

    ```sh
    brew tap FelixKratz/formulae
    brew install svim
    ```

2. Update config in `.config/svim`
3. Start the brew service

    ```sh
    brew services start svim
    ```

4. You can change the macOS selection color using:

    ```sh
    defaults write NSGlobalDomain AppleHighlightColor -string "0.615686 0.823529 0.454902"
    ```
