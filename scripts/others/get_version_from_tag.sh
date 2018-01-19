VERSION_STR=$(git describe --abbrev=0)
if  [[ $VERSION_STR = *[!\ ]* ]]; then
	echo $VERSION_STR > VERSION
fi