#!/bin/bash

if [ ! -d ~/.rbenv ]; then
  echo ""
  echo "You don't appear to have a Ruby installed in ~/.rbenv. Exiting ..."
  echo ""
  exit 1
fi

/bin/rm -fr ~/.rbenv ~/.local/state/gem ~/.gemrc

sed -i '/^export PATH="$HOME\/.rbenv\/bin:$PATH"$/d' ~/.bash_profile
sed -i '/^eval "$.~\/.rbenv\/bin\/rbenv init - bash."$/d' ~/.bash_profile
sed -i '/^export PATH="$HOME\/.rbenv\/plugins\/ruby-build\/bin:$PATH"$/d' ~/.bash_profile

echo ''
echo 'Ruby and Rails removed. Run ~/installruby.sh if you need to re-install.'

echo ''
echo '**********************************************************'
echo ''
echo ' Log out and back in again for the changes to take effect'
echo ''
echo '**********************************************************'

