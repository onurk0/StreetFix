#!/bin/bash

###########################################################################
# Use the two variables below to set the Ruby and Rails versions to install
###########################################################################

export RUBYVER=4.0.1
#export RAILSVER=8.1.2 # if commented out, Ruby will pick the best/latest version


###########################################################################

if [ -d ~/.rbenv ]; then
  echo ""
  echo "A version of ruby may already be installed in this account ... or at least attempted to be installed."
  echo "To re-install ruby, run the command below before re-runing the installation script."
  echo ""
  #echo "   /bin/rm -fr ~/.rbenv"
  echo "   ./uninstallruby.sh"
  echo ""
  exit 1
fi

# Install rbenv
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

echo $PATH | grep '/.rbenv/' >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  export PATH="$HOME/.rbenv/bin:$PATH"
  echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bash_profile
  eval "$(rbenv init -)"
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

# Install Ruby
rbenv install -v $RUBYVER
rbenv global $RUBYVER

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(~/.rbenv/bin/rbenv init - bash)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

which ruby
ruby -v
echo ""

# Disable Rubygems from generating local documentation
if [ -r ~/.gemrc ]; then
  grep '^gem: --no-document$' ~/.gemrc >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "gem: --no-document" > ~/.gemrc
  fi
else
  echo "gem: --no-document" > ~/.gemrc
fi

# Install bundler Gem
gem install bundler

# Install Rails
gem install rails # -v $RAILSVER

rbenv rehash

rails -v
echo ""

# All done.  

## The command below will create a test Rails app.
# cd ~
# rails new testapp
# cd testapp
# rake db:create
# rails server --binding=0.0.0.0

echo ''
echo '**********************************************************'
echo ''
echo ' Log out and back in again for the changes to take effect'
echo ''
echo '**********************************************************'
