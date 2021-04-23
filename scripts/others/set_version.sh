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

VERSION_STR=$1

if [[ "$VERSION_STR" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    DISPLAY_VERSION=$(echo $VERSION_STR | grep -o -E ^[0-9]+\.[0-9]+) &&\
    BUILD_NUMBER=$(echo $VERSION_STR | grep -o -E [0-9]+$) &&\
    fastlane run increment_version_number version_number:$DISPLAY_VERSION  &&\
    fastlane run increment_build_number build_number:$BUILD_NUMBER
    
    #   Output version & build numbers into a label on LaunchScreen.storyboard
    # sed -i bak -e "/userLabel=\"APP_VERSION\"/s/text=\"[^\"]*\"/text=\"$VERSION_STR\"/" $PROJECT/Base.lproj/LaunchScreen.storyboard
else
    error "Illegal version: $VERSION_STR. Should match ^[0-9]+\.[0-9]+\.[0-9]+\$"
    exit 1
fi
