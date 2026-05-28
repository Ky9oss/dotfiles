#!/bin/bash
#
# Download from internet
#
# $1: url
# By Ky9oss

TARGET_DIR="$HOME/tools/"

# $1: url
check_url() {
    if [[ $1 =~ http[s]?://.* ]]; then
        echo "matched"
    else
        exit 1
    fi
}

# $@: all executables
check_executable() {
    local f=0
    for i in "$@"; do
        if ! which "$i"; then
            printf "ERROR: %s does not exist" "$i"
            f=1
        fi
    done

    if [[ "$f" -eq 1 ]]; then
        exit 1
    fi
}

# $1: url
download() {
    check_url "$1"
    check_executable proxychains wget tar

    cd "$TARGET_DIR" || exit

    local filename
    output=$(proxychains -q wget "$1" 2>&1) # wget default log to stderr :-(

    # echo "output: $output"

    if [[ "$output" =~ -[[:space:]][^[:space:]](.*)[^[:space:]][[:space:]]saved ]]; then
        filename=${BASH_REMATCH[1]}
        # echo "filename: $filename"
    else
        printf "ERROR: Download failed. Please check your network."
        exit 1
    fi

    if [[ $filename =~ .*tar.gz || $filename =~ .*tgz ]]; then
        tar -zxf "$filename"
    elif [[ $filename =~ .*tar.xz ]]; then
        tar -xf "$filename"
    else
        printf "WARNING: \"%s\" dose not support automatic extraction." $filename
    fi

    echo "done"
}

# BASH_SOURCE is always the script's name; $0 is the caller's name if it has
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    download "$@"
fi
