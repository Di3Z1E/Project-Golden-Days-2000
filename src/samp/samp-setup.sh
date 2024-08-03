#!/bin/bash

# Define paths
CONTAINER_NAME="samp-server"
SOURCE_PATH="/srv/samp03/"
LOCAL_PATH="${HOME}/golden_days_2000/game_servers/samp"
TMP_PATH="/tmp/local_sync"

# Create local and temporary directories if they don't exist
mkdir -p "$LOCAL_PATH"
mkdir -p "$TMP_PATH"

# Function to sync files from container to local
initial_sync() {
    echo "Copying files from container to local..."
    docker cp "$CONTAINER_NAME:$SOURCE_PATH" "$LOCAL_PATH"
}

# Function to sync files from local to container
sync_files() {
    echo "Syncing files to container..."
    rsync -av --delete "$LOCAL_PATH/" "$TMP_PATH/"
    
    echo "Copying files into the container..."
    docker cp "$TMP_PATH/." "$CONTAINER_NAME:$SOURCE_PATH"
}

# Perform initial sync if not already done
if [ ! -d "$LOCAL_PATH/some_file_or_directory" ]; then
    initial_sync
fi

# Loop to sync files every second
while true; do
    sync_files
    sleep 1
done
