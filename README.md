# laptop
Setup your Linux laptop for Rails development

# Installation

This command runs the script in bash to install various awesome applications for development
`bash <(curl -fsSL https://raw.githubusercontent.com/jellene4eva/laptop/master/install.sh)`

### Applications includes
* git
* git flow
* vim
* vundle
* sqlite3
* postgresql
* imagemagick
* zsh
* Oh-My-Zsh
* nodejs
* checkinstall
* ag
* rbenv
* ruby
* bundler
* tmux
* lnav
* tig

The installer will look out for `~/.laptop.local` file, and proceed to install those as well.
Add your local file before running the script. Example:
```
#!/bin/bash
# ~/.laptop.local

sudo apt-get install -y vlc
sudo apt-get install -y skype
sudo apt-get install -y dropbox

gem_install_or_update teamocil
gem_install_or_update foreman
```

# Credit
Thoughtbot discontinued linux laptop script
https://github.com/thoughtbot/laptop/blob/3897ad81ee241cbff4501e779c8cde50de79e142/linux

# Note
I use this as on my own laptop, so I have my laptop.local here as well to make it easier for my to copy and paste into `~/.laptop.local`
