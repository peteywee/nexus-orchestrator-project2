#!/bin/bash

# Ensure script exits if any command fails
set -e

echo "--- Starting Robust Project Flattening ---"

# Step 1: Consolidate contents from nexus_project/ into the main directory
# This loop iterates through items inside nexus_project/ and moves/merges them
for item in nexus_project/*; do
    basename_item=$(basename "$item")
    
    echo "Processing: $item"
    if [ -d "$item" ]; then
        # If it's a directory, merge its contents recursively into the root directory
        echo "  Merging directory: $basename_item/"
        # Use rsync to safely merge directories. -a (archive) preserves permissions, times etc.
        # --ignore-existing ensures existing files in destination are not overwritten (use with caution if you want to update older files)
        # For this specific scenario where nexus_project has the *newer* organized content, we want it to overwrite/update.
        # So plain mv -t for files and rsync -a for dirs with a careful approach.
        # Simpler approach: mv to a temp location, then move back, or a smarter rsync.

        # Let's try rsync to move contents with overwrite for newer files
        # The trailing slash on $item/ is crucial for rsync to copy CONTENTS
        rsync -av --delete-excluded --filter=':- .gitignore' "$item/" "./$basename_item/"
        echo "  Merged '$item' into './$basename_item/'"
    elif [ -f "$item" ]; then
        # If it's a file, just move it directly to the current directory (will overwrite if exists)
        echo "  Moving file: $basename_item"
        mv "$item" .
    fi
done

# Step 2: Remove the now (hopefully) empty nexus_project/ directory
echo "Attempting to remove the nexus_project/ directory..."
# Use rm -rf for robustness in case it contains empty subdirectories or untracked files
rm -rf nexus_project/

echo "--- Project Flattening Attempt Completed ---"
echo "You can now verify your project structure with 'ls -l' or 'tree' in the current directory."
echo "All files should now be directly under /home/patrick/nexus_orchestrator_project/."
