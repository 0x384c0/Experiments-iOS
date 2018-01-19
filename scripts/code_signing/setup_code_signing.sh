set -e 
usage () {
  echo "USAGE: sh install_sert.sh \"/path/to/codesigning/files\" \"p12_password\" \"user_password\""
  exit
}
install_prov_profile(){
	IN_PROFILE_DIR=$1
	PROFILES_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"

	if [ ! -d "$PROFILES_DIR" ]; then
	  mkdir -p "$PROFILES_DIR"
	fi

	cp -R "$IN_PROFILE_DIR" "$PROFILES_DIR"
}

create_keychain(){
	KEYCHAIN_NAME="CodeSign.keychain"
	KEYCHAIN_PASS=""

	var="$(security list-keychain | grep ${KEYCHAIN_NAME})"
	if [[ $var == "" ]]; then
		echo "CREATING EMPTY KEYCHAIN"
		# Create temp keychain
		security create-keychain -p "$KEYCHAIN_PASS" $KEYCHAIN_NAME
		# Append keychain to the search list
		security list-keychains -d user -s $KEYCHAIN_NAME $(security list-keychains -d user | sed s/\"//g)
		security list-keychains
	fi
	# Unlock the keychain
	echo "UNLOCKING KEYCHAIN" 
	security unlock-keychain -p "$KEYCHAIN_PASS" $KEYCHAIN_NAME
	security set-keychain-settings -l -u -t 3600 $KEYCHAIN_NAME
	security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k $MATCH_PASSWORD $KEYCHAIN_NAME

}

install_sert(){
	P12_PATH=$1
	create_keychain
	security import $P12_PATH -k $KEYCHAIN_NAME -A -P "$P12_PASS"
}

CODE_SIGN_PATH=$1
P12_PASS=$2
[ -e $CODE_SIGN_PATH ] || usage
# [ -n $P12_PASS ] || usage

# echo $CODE_SIGN_PATH
# echo $P12_PASS

for f in $CODE_SIGN_PATH/*.p12; do
	echo "Installing: $f"
	install_sert $f
done

for f in $CODE_SIGN_PATH/*.mobileprovision; do
	echo "Installing: $f"
	install_prov_profile $f
done