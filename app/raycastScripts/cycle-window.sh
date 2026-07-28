#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Cycle Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔁
# @raycast.packageName Window Utils

# Documentation:
# @raycast.description Cycles to the next window within the current application (simulates Cmd+`)
# @raycast.author jason

osascript -e 'tell application "System Events" to key code 50 using command down'
