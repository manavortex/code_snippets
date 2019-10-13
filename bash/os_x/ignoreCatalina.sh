#!/bin/bash

# Locate Caching Servers
/usr/bin/AssetCacheLocatorUtil

# Reset ignored updates
sudo /usr/sbin/softwareupdate --reset-ignored
sudo /usr/sbin/softwareupdate --ignore "macOS Catalina"

defaults write com.apple.systempreferences AttentionPrefBundleIDs 0
killall Dock
