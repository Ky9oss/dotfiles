#!/bin/bash
#
# A progress bar written in bash by Ky9oss.
# Fork from https://github.com/pollev/bash_progress_bar
# It's not a good implementation for progress bar because there are different ANSI sequences in `terminfo`. Using ncurses, notcurses or tvision is a better choice.

# Usage:
# Source this script
# setup_scroll_area <- create empty progress bar
# draw_progress_bar 10 100 <- draw progress bar
# draw_progress_bar 40 100 <- draw progress bar
# draw_progress_bar 90 100 <- draw progress bar
# destroy_scroll_area <- remove progress bar

# Constants
CODE_SAVE_CURSOR="\033[s"
CODE_RESTORE_CURSOR="\033[u"
CODE_CURSOR_IN_SCROLL_AREA="\033[1A"
COLOR_FG="\e[30m"
COLOR_BG="\e[42m"
COLOR_BG_BLOCKED="\e[43m"
RESTORE_FG="\e[39m"
RESTORE_BG="\e[49m"

CURRENT_NR_LINES=0
PROGRESS_TITLE=""

# shellcheck disable=SC2120
# $1: progress bar title
# $2: total node
setup_progress_bar() {

    [ -n "$1" ] && PROGRESS_TITLE="$1" || PROGRESS_TITLE="Progress"
    if [[ -n "$2" ]]; then
        total_node=$2
    else
        printf "ERROR: setup_scroll_area()"
    fi

    lines=$(tput lines)
    CURRENT_NR_LINES=$lines
    lines=$((lines - 1))
    # Scroll down a bit to avoid visual glitch when the screen area shrinks by one row
    echo -en "\n"

    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"
    # Set scroll region (this will place the cursor in the top left)
    echo -en "\033[0;${lines}r"

    # Restore cursor but ensure its inside the scrolling area
    echo -en "$CODE_RESTORE_CURSOR"
    echo -en "$CODE_CURSOR_IN_SCROLL_AREA"

    # Start empty progress bar
    draw_progress_bar 0 "$total_node"
}

destroy_scroll_area() {
    lines=$(tput lines)
    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"
    # Set scroll region (this will place the cursor in the top left)
    echo -en "\033[0;${lines}r"

    # Restore cursor but ensure its inside the scrolling area
    echo -en "$CODE_RESTORE_CURSOR"
    echo -en "$CODE_CURSOR_IN_SCROLL_AREA"

    # We are done so clear the scroll bar
    clear_progress_bar

    # Scroll down a bit to avoid visual glitch when the screen area grows by one row
    echo -en "\n\n"

    # Reset title for next usage
    PROGRESS_TITLE=""
}

# $1: current node
# $2: total node
# $3: extra info | nil
draw_progress_bar() {

    if [[ "$1" -gt 0 ]]; then
        current_node="$1"
    elif [[ "$1" -eq 0 ]]; then
current_node=200
total_node=50

percentage=$("$current_node"*100/"$total_node")
        current_node=1
    else
        printf "ERROR: current node can not be less than 0."
        exit 1
    fi

    if [[ "$2" -ge "$current_node" ]]; then
        total_node="$2"
    else
        printf "ERROR: total node can not be less than current node."
        exit 1
    fi

    [ -n "$3" ] && extra="$3" || extra=""

    percentage=$((current_node * 100 / total_node))
    lines=$(tput lines)

    # Check if the window has been resized. If so, reset the scroll area
    # if [ "$lines" -ne "$CURRENT_NR_LINES" ]; then
    #     setup_scroll_area
    # fi

    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"

    # Move cursor position to last row
    echo -en "\033[${lines};0f"

    # Clear progress bar
    tput el

    # Draw progress bar
    print_bar_text "$percentage" "$extra"

    # Restore cursor position
    echo -en "$CODE_RESTORE_CURSOR"
}

clear_progress_bar() {
    lines=$(tput lines)
    lines=$((lines))
    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"

    # Move cursor position to last row
    echo -en "\033[${lines};0f"

    # clear progress bar
    tput el

    # Restore cursor position
    echo -en "$CODE_RESTORE_CURSOR"
}

# $1: percentage
# $2: extra info
print_bar_text() {
    local percentage=$1
    local extra=$2
    [ -n "$extra" ] && extra=" ($extra)"
    local cols=$(tput cols)
    bar_size=$((cols - 9 - ${#PROGRESS_TITLE} - ${#extra}))

    local color="${COLOR_FG}${COLOR_BG}"
    # if [ "$PROGRESS_BLOCKED" = "true" ]; then
    #     color="${COLOR_FG}${COLOR_BG_BLOCKED}"
    # fi

    # Prepare progress bar
    complete_size=$(((bar_size * percentage) / 100))
    remainder_size=$((bar_size - complete_size))
    progress_bar=$(
        echo -ne "["
        echo -en "${color}"
        printf_new "#" $complete_size
        echo -en "${RESTORE_FG}${RESTORE_BG}"
        printf_new "." $remainder_size
        echo -ne "]"
    )

    # Print progress bar
    echo -ne " $PROGRESS_TITLE ${percentage}% ${progress_bar}${extra}"
}

printf_new() {
    str=$1
    num=$2
    v=$(printf "%-${num}s" "$str")
    echo -ne "${v// /$str}"
}
