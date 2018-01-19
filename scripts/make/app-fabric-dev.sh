export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

bundle exec fastlane beta  

# bundle exec fastlane gym --scheme IOSExperiments
# xcodebuild -workspace ./IOSExperiments.xcworkspace -scheme IOSExperiments -destination 'generic/platform=iOS' -archivePath /Users/andrew/Library/Developer/Xcode/Archives/2017-03-16/IOSExperiments\ 2017-03-16\ 14.03.46.xcarchive archive | xcpretty
