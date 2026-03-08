#!/usr/bin/env bash

# Link Sublime Text configuration to iCloud for cross-machine synchronisation

cd ~/Library/Application\ Support/Sublime\ Text/Packages
rm -r User
ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/Apps/Sublime/User
