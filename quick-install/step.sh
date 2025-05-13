#!/bin/bash

source "/home/tiago/.config/quick-install/print-with-color.sh"

step(){
    if [ $# -lt 2 ]; then
        #TODO: print usage
        exit 1
    fi

    local STEP=$1
    local NAME=$2
    local ARGS=$3
    ERROR=""
    printc "->        $NAME...\n"
    
    $STEP $ARGS 1>> "$LOG" 2>> "$LOG" 
    local CODE=$?

    if [ "$CODE" -eq 0 ]; then
        tput cuu1
        tput el
        printc $GREEN "[OK]      $NAME\n"
        return 0
        
    elif [ "$CODE" -eq 1 ]; then
        tput cuu1
        tput el
        printc "$YELLOW" "[WARNING] $NAME\n"
        printc "$YELLOW" "$ERROR\n" 
        return 0

    elif [ "$CODE" -eq 2 ]; then
        tput cuu1
        tput el
        printc "$RED" "[ERROR]   $NAME\n"
        printc "$RED" "$ERROR\n" 
        exit 1
    fi

}