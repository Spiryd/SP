#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <start_revision> <end_revision> <svn_url>"
    exit 1
fi

# Assign input arguments to variables
START_REV=$1
END_REV=$2
SVN_URL=$3
GIT_REPO_NAME=$(basename "$SVN_URL")  # Extract the name from the URL

# Create a new directory and initialize a Git repository
mkdir -p "$GIT_REPO_NAME"
cd "$GIT_REPO_NAME" || exit
git init

# Create a temporary directory for SVN export
TEMP_DIR=$(mktemp -d)

# Loop through the specified SVN revisions
for REV in $(seq "$START_REV" "$END_REV"); do
    echo "Processing revision $REV..."

    # Clean up the temporary directory
    rm -rf "$TEMP_DIR/*"

    # Export the SVN repository content for the current revision to the temporary directory
    svn export --force -r "$REV" "$SVN_URL" "$TEMP_DIR" || {
        echo "Error: Unable to export revision $REV. Skipping."
        continue
    }

    # Copy exported content to the Git repository, avoiding .svn, .git, and .gitignore
    rsync -a --exclude=".svn" --exclude=".git" --exclude=".gitignore" "$TEMP_DIR/" .

    # Extract the commit message from the SVN log
    COMMIT_MESSAGE=$(svn log -r "$REV" "$SVN_URL" | sed -n '4p')

    # Add all files to Git
    git add .
    
    # Commit the current state with the SVN log message
    git commit -m "Revision $REV: $COMMIT_MESSAGE"
done

# Remove the temporary directory
rm -rf "$TEMP_DIR"

# Print the Git log for the repository
echo "Git log with stats:"
git log --stat

# Filtered Git log output
echo "Filtered log:"
git log --stat | grep -v '^commit ' | grep -v '^Author: ' | grep -v '^Date: '

