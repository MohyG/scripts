#!/bin/bash
#
# Xcode / SwiftPM cleanup script
# Author: Mohyg.com
# Description:
#   Cleans Xcode DerivedData and Swift Package Manager directories.
#   Adds confirmation before deleting to prevent accidental data loss.
#

# Define paths
DERIVED_DATA=~/Library/Developer/Xcode/DerivedData
SPM_DIR1=~/Library/org.swift.swiftpm
SPM_DIR2=~/Library/Caches/org.swift.swiftpm

# Function to ask for confirmation before deleting
confirm_and_delete() {
  local target="$1"
  local msg="$2"

  if [ -d "$target" ]; then
    size_before=$(du -sh "$target" 2>/dev/null | awk '{print $1}')
    echo ""
    read -p "Delete $msg ($size_before)? [y/N] " confirm
    if [[ $confirm == [yY] ]]; then
      echo "➡️ Deleting $target ..."
      rm -rf "$target"
      echo "✅ Deleted $target."
    else
      echo "⏭️ Skipped $target."
    fi
  else
    echo "Directory $target does not exist."
  fi
}

echo "🧹 Starting Xcode / SwiftPM cleanup..."

# Delete everything in DerivedData
confirm_and_delete "$DERIVED_DATA" "contents of DerivedData (all files inside)"

# Delete the Swift Package Manager folder in the Library directory
confirm_and_delete "$SPM_DIR1" "SwiftPM Library directory"

# Delete the Swift Package Manager folder in the Caches directory
confirm_and_delete "$SPM_DIR2" "SwiftPM Caches directory"

echo ""
echo "✨ Cleanup complete. Script by Mohyg.com"
echo "Please restart Xcode to regenerate necessary files."
