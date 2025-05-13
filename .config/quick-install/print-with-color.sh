#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GREY='\033[0;37m'
CLEAR='\033[0m'


printc(){
    # Prints a string with optional color formatting.
    #
    # Usage:
    #   printc [color] <string> 
    #
    # Arguments:
    #   <string> : The string to be printed.
    #   [color]  : Optional. The color code to print the string in. If not provided, the string is printed without color.
    #
    # Returns:
    #   0 on success, exits with 1 on error.
    #
    # Errors:
    #   - If no arguments are provided, prints an error message and exits with status 1.
    #   - If more than two arguments are provided, prints an error message and exits with status 1.
    #
    # Example:
    #   printc "Hello, World!" $RED
    #   printc "Hello, World!"

    if [ $# -eq 0 ]; then
        echo -ne "${RED}ERROR: print must take at least one string as argument\n${CLEAR}" >&2
        exit 1
    
    elif [ $# -eq 1 ]; then
        echo -ne "$1"
        return 0
    
    elif [ $# -eq 2 ]; then 
        echo -ne "$1$2${CLEAR}"
        return 0
    
    else
        echo -ne "${RED}ERROR: print can't take more then two arguments\n${CLEAR}" >&2
        exit 1
    fi
}
