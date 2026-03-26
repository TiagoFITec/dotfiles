#!/bin/bash
source "/home/tiago/.config/quick-install/print-with-color.sh"

show_header(){
printf "\n"
printc  "╔════════════════════════════════════════════════════════════════════════╗\n"
printc  "║ " 
printc "$GREY" "██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ "
printc  " ║\n"
printc  "║ " 
printc "$GREY" "██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗"
printc  " ║\n"
printc  "║ " 
printc "$GREY" "██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝"
printc  " ║\n"
printc  "║ " 
printc "$GREY" "██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗"
printc  " ║\n"
printc  "║ " 
printc "$GREY" "██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║"
printc  " ║\n"
printc  "║ " 
printc "$GREY" "╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝"
printc  " ║\n"
printc  "╚════════════════════════════════════════════════════════════════════════╝\n"
printf "\n\n"
 
     # Add a shorter animation with better spacing
    for i in {1..2}; do
        tput sc
        printc "$GREEN" "  ⚡ Loading your perfect environment"
        for j in {1..3}; do
            printc "$YELLOW" "."
            sleep 0.2
        done
        tput rc
        tput el
    done
    
    printc "$GREEN" "  ✓ Ready to transform your system!\n\n"
    return 0
}