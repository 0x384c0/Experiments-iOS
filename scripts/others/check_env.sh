function error {
    if [ -z "$TERM" ];then echo "ERROR: $1";
    else echo "$(tput setaf 1; tput bold;)ERROR: $1$(tput sgr0)"; fi
}


hash xcodebuild 2>/dev/null || { error "xcode is reqiured, but it's not installed. Aborting. Install xcode and try again."; exit 1; }
hash gem 2>/dev/null || { error "gem is reqiured, but it's not installed. Aborting."; exit 1; }
hash bundle 2>/dev/null || { gem install bundler; }

bundle install



# jenkins config


# 	Shell executable    : /Users/<username>/.rvm/bin/rvm-shell
#   Env Var             : LC_ALL en_US.UTF-8
#   or
#   export LC_ALL="en_US.UTF-8"
