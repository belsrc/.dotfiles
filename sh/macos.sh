#!/usr/bin/env bash

. sh/utils.sh

mac_only() {
  OS="`uname`"

  if [ "$OS" = "Darwin" ]; then
    info "Installing Nerd Font"
    brew install font-jetbrains-mono-nerd-font

    info "Setting system preferences"

    ###############################################################################
    # General UI/UX                                                               #
    ###############################################################################

    # Close any open System Preferences panes, to prevent them from overriding
    # settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

    # Disable the sound effects on boot
    sudo nvram SystemAudioVolume=" "
    sudo nvram StartupMute=%00

    # Set sidebar icon size to medium
    defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

    # Always show scrollbars
    defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
    # Possible values: `WhenScrolling`, `Automatic` and `Always`

    ## Adjust toolbar title rollover delay
    defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

    # Save to disk (not to iCloud) by default
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

    # Disable the “Are you sure you want to open this application?” dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Reveal IP address, hostname, OS version, etc. when clicking the clock
    # in the login window
    sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

    # Disable automatic capitalization as it’s annoying when typing code
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable smart dashes as they’re annoying when typing code
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable automatic period substitution as it’s annoying when typing code
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

    # Disable smart quotes as they’re annoying when typing code
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    ###############################################################################
    # Energy saving                                                               #
    ###############################################################################

    # Enable lid wakeup
    sudo pmset -a lidwake 1

    # Restart automatically on power loss
    sudo pmset -a autorestart 1

    # Restart automatically if the computer freezes
    sudo systemsetup -setrestartfreeze on

    # Disable machine sleep while charging
    sudo pmset -c sleep 0

    # Set machine sleep to 5 minutes on battery
    sudo pmset -b sleep 5

    # Set standby delay to 24 hours (default is 1 hour)
    sudo pmset -a standbydelay 86400

    # Never go into computer sleep mode
    sudo systemsetup -setcomputersleep Off > /dev/null

    # Hibernation mode
    # 0: Disable hibernation (speeds up entering sleep mode)
    # 3: Copy RAM to disk so the system state can still be restored in case of a
    #    power failure.
    sudo pmset -a hibernatemode 0

    # Remove the sleep image file to save disk space
    sudo rm /private/var/vm/sleepimage
    # Create a zero-byte file instead…
    sudo touch /private/var/vm/sleepimage
    # …and make sure it can’t be rewritten
    sudo chflags uchg /private/var/vm/sleepimage

    ###############################################################################
    # Screen                                                                      #
    ###############################################################################

    # Save screenshots to the desktop
    defaults write com.apple.screencapture location -string "${HOME}/Desktop"

    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    defaults write com.apple.screencapture type -string "png"

    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true

    # Enable subpixel font rendering on non-Apple LCDs
    # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
    defaults write NSGlobalDomain AppleFontSmoothing -int 1

    # Enable HiDPI display modes (requires restart)
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

    ###############################################################################
    # Finder                                                                      #
    ###############################################################################

    # Finder: disable window animations and Get Info animations
    defaults write com.apple.finder DisableAllAnimations -bool true

    # Finder: show hidden files by default
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Finder: show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Finder: show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Finder: show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Enable spring loading for directories
    defaults write NSGlobalDomain com.apple.springing.enabled -bool true

    # Remove the spring loading delay for directories
    defaults write NSGlobalDomain com.apple.springing.delay -float 0

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Disable disk image verification
    defaults write com.apple.frameworks.diskimages skip-verify -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

    # Automatically open a new Finder window when a volume is mounted
    defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
    defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
    defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

    # Enable snap-to-grid for icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

    # Increase grid spacing for icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 60" ~/Library/Preferences/com.apple.finder.plist

    # Increase the size of icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist

    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Show the ~/Library folder
    chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

    # Show the /Volumes folder
    sudo chflags nohidden /Volumes
  fi
}
