function banner {
    if [ -z ${TERM+x} ]; then echo "######## $1 #######";
    else echo "$(tput setaf 5; tput bold;)######## $1 #######$(tput sgr0)"; fi
}
function info {
    if [ -z ${TERM+x} ];then echo "INFO: $1";
    else echo "$(tput setaf 2; tput bold;)INFO: $1$(tput sgr0)"; fi
}

set -e
VERSION_STR=$(cat VERSION)
PROJECT=IOSExperiments

semver=( ${VERSION_STR//./ } )
major="${semver[0]}"
minor="${semver[1]}"
patch="${semver[2]}"

BUNDLE_VERSION=$patch
SHORT_BUNDLE_VERSION="${major}.${minor}"
banner "Will set version for $PROJECT"
info "major:    $major"
info "minor:    $minor"
info "patch:    $patch"
info "BUNDLE_VERSION:        $BUNDLE_VERSION"
info "SHORT_BUNDLE_VERSION:  $SHORT_BUNDLE_VERSION"

if [[ $BUNDLE_VERSION = *[!\ ]* ]]; then
    plutil -replace CFBundleVersion -string $BUNDLE_VERSION $PROJECT/Info.plist
    plutil -replace CFBundleVersion -string $BUNDLE_VERSION $PROJECT/Dev-Info.plist

    plutil -replace CFBundleShortVersionString -string $SHORT_BUNDLE_VERSION $PROJECT/Info.plist
    plutil -replace CFBundleShortVersionString -string $SHORT_BUNDLE_VERSION $PROJECT/Dev-Info.plist

    #   Output version & build numbers into a label on LaunchScreen.storyboard
	# sed -i bak -e "/userLabel=\"APP_VERSION\"/s/text=\"[^\"]*\"/text=\"$VERSION_STR\"/" $PROJECT/Base.lproj/LaunchScreen.storyboard

fi

banner DONE
