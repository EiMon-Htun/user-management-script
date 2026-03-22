#!/bin/bash

# Load config
source config.conf

# Logging
LOGFILE="user_management.log"
echo "Running script at $(date)" >> $LOGFILE

# Check group exists
if ! getent group $GROUP > /dev/null; then
    sudo groupadd $GROUP
    if [ $? -ne 0 ]; then
        echo "Error creating group $GROUP" >> $LOGFILE
    else
        echo "Group $GROUP created" >> $LOGFILE
    fi
else
    echo "Group $GROUP already exists" >> $LOGFILE
fi

# Read users file
while read user; do
    if id "$user" &>/dev/null; then
        echo "User $user already exists" >> $LOGFILE
    else
        sudo useradd -m -G $GROUP $user
        if [ $? -ne 0 ]; then
            echo "Error creating user $user" >> $LOGFILE
        else
            echo "User $user created" >> $LOGFILE
        fi
    fi
done < users.txt

