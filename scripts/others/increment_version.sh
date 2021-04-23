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

OLD_VERSION_STR=$1
version_to_increment=$2

if [[ $OLD_VERSION_STR == "" ]]; then
    warn "Usage: increment_version.sh 1.0.0 patch"
    exit 1
fi

if ! [[ "$OLD_VERSION_STR" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    error "Illegal version. Should match ^[0-9]+\.[0-9]+\.[0-9]+\$"
    exit 1
fi

banner "Will increment version"
#get version

#parse
semver=( ${OLD_VERSION_STR//./ } )
major="${semver[0]}"
minor="${semver[1]}"
patch="${semver[2]}"

#increment
if [ "$version_to_increment" = "minor" ]; then
    minor=$((minor+1))
    patch=0
elif [ "$version_to_increment" = "major" ]; then
    major=$((major+1))
    minor=0
    patch=0
else
    patch=$((patch+1))
fi

NEW_VERSION_STR="${major}.${minor}.${patch}"

info "Old version number: $OLD_VERSION_STR"
info "New version number: $NEW_VERSION_STR"

#save
banner DONE

echo $NEW_VERSION_STR
