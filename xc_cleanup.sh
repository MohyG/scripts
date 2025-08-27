#!/bin/bash
#
# Xcode / macOS cleanup script
# Author: Mohyg.com
# Description:
#   Deletes heavy Xcode / macOS cache directories with confirmation prompts.
#   Shows estimated and actual disk space freed.
#

# Directories to clean
DIRS=(
  "$HOME/Library/Developer/Xcode/iOS DeviceSupport"
  "$HOME/Library/Developer/Xcode/DerivedData"
  "$HOME/Library/Developer/CoreSimulator/Caches"
  "$HOME/Library/Developer/CoreSimulator/Devices"
  "$HOME/Library/Developer/Xcode/DocumentationCache"
  "$HOME/Library/Developer/Xcode/Archives"
  "$HOME/Library/Developer/Xcode/iOS Device Logs"
  "$HOME/Library/Caches"
  "$HOME/Library/Logs"
)

echo "🧹 Starting cleanup..."

# Get initial disk usage
before=$(df -k "$HOME" | tail -1 | awk '{print $4}')

total_freed=0

for dir in "${DIRS[@]}"; do
  if [ -d "$dir" ]; then
    size_before=$(du -sk "$dir" | awk '{print $1}')
    size_gb=$(echo "scale=2; $size_before/1024/1024" | bc)
    echo ""
    read -p "Delete $dir (size: ${size_gb} GB)? [y/N] " confirm
    if [[ $confirm == [yY] ]]; then
      echo "➡️ Deleting $dir ..."
      sudo rm -rf "$dir"
      total_freed=$((total_freed + size_before))
      echo "✅ Deleted $dir"
    else
      echo "⏭️ Skipped $dir"
    fi
  else
    echo "Skipping $dir (not found)"
  fi
done

# Calculate freed space in GB
freed_gb=$(echo "scale=2; $total_freed/1024/1024" | bc)

# Get final disk usage
after=$(df -k "$HOME" | tail -1 | awk '{print $4}')
actual_freed=$(echo "scale=2; ($after - $before)/1024/1024" | bc)

echo ""
echo "✨ Cleanup complete."
echo "Estimated space freed: ${freed_gb} GB"
echo "Disk reports space freed: ${actual_freed} GB"
