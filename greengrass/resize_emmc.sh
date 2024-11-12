#!/bin/bash

# define the device (eMMC)
DEVICE="/dev/mmcblk2"
PARTITION="${DEVICE}p2"  # Adjust this to the specific partition number, e.g., mmcblk2p2

# check if the device exists
if [ ! -b "$DEVICE" ]; then
    echo "Device $DEVICE not found."
    exit 1
fi

# check if the partition exists
if [ ! -b "$PARTITION" ]; then
    echo "Partition $PARTITION not found."
    exit 1
fi

# install parted if not already installed
if ! command -v parted &> /dev/null; then
    echo "Installing parted..."
    apt update && apt -y install parted
fi

echo "Starting resize process on $PARTITION..."

# step 1: Resize the partition
# set the partition to use all remaining space (using `parted`)
parted "$DEVICE" resizepart 2 100% || {
    echo "Failed to resize partition."
    exit 1
}

# step 2: Resize the filesystem
# run resize2fs on the partition to fill the resized space
resize2fs "$PARTITION" || {
    echo "Failed to resize filesystem."
    exit 1
}

# disable memory resizing service so it does not run on next boot
# systemctl disable resize_emmc.service

echo "Resize completed successfully on $PARTITION."