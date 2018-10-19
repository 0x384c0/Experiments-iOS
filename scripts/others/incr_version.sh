function banner {
    if [ -z "$TERM" ]; then echo "######## $1 #######";
    else echo "$(tput setaf 5; tput bold;)######## $1 #######$(tput sgr0)"; fi
}
function info {
    if [ -z "$TERM" ];then echo "INFO: $1";
    else echo "$(tput setaf 2; tput bold;)INFO: $1$(tput sgr0)"; fi
}
function warn {
    if [ -z "$TERM" ];then echo "WARNING: $1";
    else echo "$(tput setaf 3; tput bold;)WARNING: $1$(tput sgr0)"; fi
}
function error {
    if [ -z "$TERM" ];then echo "ERROR: $1";
    else echo "$(tput setaf 1; tput bold;)ERROR: $1$(tput sgr0)"; fi
}

banner "Will increment version"
#get version
OLD_VERSION_STR=$(cat VERSION)

#parse
semver=( ${OLD_VERSION_STR//./ } )
major="${semver[0]}"
minor="${semver[1]}"
patch="${semver[2]}"

#increment
patch=$((patch+1))
NEW_VERSION_STR="${major}.${minor}.${patch}"

info "Old version number: $OLD_VERSION_STR"
info "New version number: $NEW_VERSION_STR"

#save
git tag -a $NEW_VERSION_STR -m "incremented version"
git push origin $NEW_VERSION_STR
echo $NEW_VERSION_STR > VERSION

banner DONE
