#!/bin/sh
function banner {
    if [ -z "$TERM" ]; then >&2 echo "######## $1 #######";
    else >&2 echo "$(tput setaf 5; tput bold;)######## $1 #######$(tput sgr0)"; fi
}
function info {
    if [ -z "$TERM" ];then >&2 echo "INFO: $1";
    else >&2 echo "$(tput setaf 2; tput bold;)INFO: $1$(tput sgr0)"; fi
}
function warn {
    if [ -z "$TERM" ];then >&2 echo "WARNING: $1";
    else >&2 echo "$(tput setaf 3; tput bold;)WARNING: $1$(tput sgr0)"; fi
}
function error {
    if [ -z "$TERM" ];then >&2 echo "ERROR: $1";
    else >&2 echo "$(tput setaf 1; tput bold;)ERROR: $1$(tput sgr0)"; fi
}

VERSION_STR=$(git tag --sort=-creatordate | head -1)

if [[ "$VERSION_STR" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo $VERSION_STR
else
    error "Illegal version: $VERSION_STR. Should match ^[0-9]+\.[0-9]+\.[0-9]+\$"
    exit 1
fi
