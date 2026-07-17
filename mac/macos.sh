#!/usr/bin/env bash

# macOS system preferences — run via install.sh or directly: bash mac/macos.sh
#
#   1. General UI & system
#   2. Finder
#   3. Dock
#   4. Keyboard & input
#   5. Trackpad
#   6. Safari & Mail (mostly disabled — see note)
#   7. Apply (restart affected apps)
#
# Commented-out settings are kept on purpose: they're the menu of options —
# uncomment to enable. See mac/README.md for what each setting does.

# Best-effort: a single failed `defaults write` (e.g. a TCC-protected domain)
# must not abort the whole installer. Errors are surfaced inline.
set +e

echo -e "\\n\\nSetting MacOS settings"
echo "=============================="

# ═══ 1. General UI & system ═══

echo "Dark Mode"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

echo "Graphite accent, grey highlight, and window controls (matches the greyscale terminal/nvim theme)"
defaults write NSGlobalDomain AppleAccentColor -int -1
# Custom mid-grey selection highlight (#767676) instead of the Graphite
# preset: the preset is a light grey that vanishes behind light text in
# dark-mode apps (e.g. selecting text in Slack). Mid grey stays readable
# against both white and black text.
defaults write NSGlobalDomain AppleHighlightColor -string "0.462745 0.462745 0.462745"
defaults write NSGlobalDomain AppleAquaColorVariant -int 6

echo "Expand save dialog by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "Enable full keyboard access for all controls (e.g. Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

# echo "Expand print panel by default"
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

echo "Show scroll bars only while scrolling"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# echo "Disable opening and closing window animations"
# defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# echo "Increase window resize speed for Cocoa applications"
# defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# echo "Display ASCII control characters using caret notation in standard text views"
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
# defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# echo "Disable Resume system-wide"
# defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# echo "Disable the 'reopen windows when logging back in' option"
# This works, although the checkbox will still appear to be checked.
# defaults write com.apple.loginwindow TALLogoutSavesState -bool false
# defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# echo "Require password immediately after sleep or screen saver begins"
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# echo "Disable shadow in screenshots"
# defaults write com.apple.screencapture disable-shadow -bool true

# echo "Disable disk image verification"
# defaults write com.apple.frameworks.diskimages skip-verify -bool true
# defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
# defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# echo "Automatically open a new Finder window when a volume is mounted"
# defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
# defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
# defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# ═══ 2. Finder ═══

echo "New Finder windows open the home directory"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

echo "Hide Recent Tags in the Finder sidebar"
defaults write com.apple.finder ShowRecentTags -bool false

echo "Use column view by default in Finder windows"
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

echo "Hide hidden files by default (toggle in Finder with Cmd+Shift+.)"
defaults write com.apple.Finder AppleShowAllFiles -bool false

echo "Use current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Hide the Path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool false

echo "Hide the Status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool false

# echo "Finder: show all filename extensions"
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# echo "show the ~/Library folder in Finder"
# chflags nohidden ~/Library

# echo "Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons"
# defaults write com.apple.finder QuitMenuItem -bool true

# echo "Disable window animations and Get Info animations in Finder"
# defaults write com.apple.finder DisableAllAnimations -bool true

# echo "Display full POSIX path as Finder window title"
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# echo "Avoid creating .DS_Store files on network volumes"
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# echo "Disable the warning when changing a file extension"
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# echo "Show item info below desktop icons"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# echo "Enable snap-to-grid for desktop icons"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# echo "Disable the warning before emptying the Trash"
# defaults write com.apple.finder WarnOnEmptyTrash -bool false

# echo "Empty Trash securely by default"
# defaults write com.apple.finder EmptyTrashSecurely -bool true

# ═══ 3. Dock ═══

echo "Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "Position the Dock on the right side of the screen"
defaults write com.apple.dock orientation -string "right"

echo "Magnify Dock icons on hover (to size 58)"
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 58

echo "Minimize windows into their application's icon"
defaults write com.apple.dock minimize-to-application -bool true

echo "Hide the recent applications section in the Dock"
defaults write com.apple.dock show-recents -bool false

# echo "Enable the 2D Dock"
# defaults write com.apple.dock no-glass -bool true

# echo "Make Dock icons of hidden applications translucent"
# defaults write com.apple.dock showhidden -bool true

# echo "Enable highlight hover effect for the grid view of a stack (Dock)"
# defaults write com.apple.dock mouse-over-hilte-stack -bool true

# echo "Enable spring loading for all Dock items"
# defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# echo "Show indicator lights for open applications in the Dock"
# defaults write com.apple.dock show-process-indicators -bool true

# echo "Don't animate opening applications from the Dock"
# defaults write com.apple.dock launchanim -bool false

# ═══ 4. Keyboard & input ═══

echo "Remap Caps Lock to Control (all keyboards; per-host preference)"
defaults -currentHost write -g com.apple.keyboard.modifiermapping.0-0-0 -array \
  '<dict><key>HIDKeyboardModifierMappingSrc</key><integer>30064771129</integer><key>HIDKeyboardModifierMappingDst</key><integer>30064771300</integer></dict>'

echo "Pressing fn changes the input source (Australian <-> Pinyin)"
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

echo "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1

echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# echo "Disable auto-correct"
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ═══ 5. Trackpad ═══

echo "Enable tap to click (Trackpad)"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# echo "Map bottom right Trackpad corner to right-click"
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# ═══ 6. Safari & Mail ═══

# Safari tweaks removed: Safari preferences are TCC-protected and need the
# terminal to have Full Disk Access — two cosmetic settings (internal debug
# menu, bookmarks bar icons) are not worth that grant. Set them manually in
# Safari's own settings if wanted.

# echo "Disable Safari's thumbnail cache for History and Top Sites"
# defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# echo "Make Safari's search banners default to Contains instead of Starts With"
# defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# echo "Add a context menu item for showing the Web Inspector in web views"
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# echo "Disable send and reply animations in Mail.app"
# defaults write com.apple.Mail DisableReplyAnimations -bool true
# defaults write com.apple.Mail DisableSendAnimations -bool true

# ═══ 7. Apply ═══

echo "Kill affected applications"
for app in Finder Dock Mail SystemUIServer; do
    killall "$app" >/dev/null 2>&1 || true
done
