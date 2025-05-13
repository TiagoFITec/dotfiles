#!/bin/bash



config_log(){
    local LOG_DIR="/home/tiago/.config/quick-install"
    local ADMIN_USER="tiago"
    LOG="$LOG_DIR/$1"
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
    fi

    if [ ! -f "$LOG" ]; then
        sudo touch "$LOG"
        sudo chown -R $ADMIN_USER:$ADMIN_USER "$LOG"
    fi

    date 1>$LOG

    return 0

}