all:
	$(MAKE) calabash

# MAKE
fabric_all:
	$(MAKE) fabric-dev
	$(MAKE) fabric-dev-bank

fabric_dev:
	$(MAKE) check_env
	$(MAKE) clean
	$(MAKE) set_version
	sh scripts/make/app-fabric-dev.sh

appstore:
	$(MAKE) check_env
	$(MAKE) clean
	$(MAKE) set_version
	sh scripts/make/app-appstore.sh

calabash:
	$(MAKE) check_env
	$(MAKE) clean
	$(MAKE) cocoapods
	sh scripts/make/app-cal.sh

# CODE SIGNING
# make setup_code_signing CODE_SIGN_PATH="/path/to/code_sign/files" P12_PASS="password_p12" USER_PASS="password"
setup_code_signing:
	sh scripts/code_signing/setup_code_signing.sh $(CODE_SIGN_PATH) $(P12_PASS) $(USER_PASS)

unlock_keychans:
	#make unlock_keychans LOGIN_KEYCHAN_PASSWORD=<login_pass>
	security unlock-keychain -p "" "CodeSign.keychain"
	security unlock-keychain -p "$(LOGIN_KEYCHAN_PASSWORD)"   ~/Library/Keychains/login.keychain

# OTHERS
check_env:
	sh scripts/others/check_env.sh

clean:
	rm -rf tmp
	rm -rf build
	rm -rf Products
	rm -rf xtc-submit-*
	rm -rf *.ipa
	rm -rf *.app.dSYM
	rm -rf *.app.dSYM.zip
	rm -rf *.app
	rm -rf xtc-

cocoapods:
	bundle exec pod install

increment_version:
	VERSION=$$(sh scripts/others/get_version_from_tag.sh) &&\
	NEW_VERSION=$$(sh scripts/others/increment_version.sh $$VERSION) &&\
	sh scripts/others/set_version.sh $$NEW_VERSION

create_release:
	export GIT_MERGE_AUTOEDIT=no &&\
	VERSION=$$(sh scripts/others/get_version_from_tag.sh) &&\
	NEW_VERSION=$$(sh scripts/others/increment_version.sh $$VERSION) &&\
	git flow release start $$NEW_VERSION  &&\
	sh scripts/others/set_version.sh $$NEW_VERSION  &&\
	git add --all  &&\
	git commit -m "Version $$NEW_VERSION" &&\
	git flow release finish -m "Version_$$NEW_VERSION" "$$NEW_VERSION" &&\
	unset GIT_MERGE_AUTOEDIT &&\
	git push --all &&\
	git push --tags


