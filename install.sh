#!/bin/sh

# #
sudo apt-get install i3 i3blocks emacs25 fonts-font-awesome fonts-emojione ttf-mscorefonts-installer \
     keepassx git firefox compton


ln -s .xinitrc ~/.xinitrc
ln -s .Xresources  ~/.Xresources 
ln -s i3/config ~/.config/i3/config
ln -s termite/config ~/.config/termite/config
ln -s zshrc ~/.zshrc
ln -s Xmodmap ~/.Xmodmap



echo "\n* Downloading version $version of source code pro font"
wget https://github.com/adobe-fonts/source-code-pro/releases/download/variable-fonts/SourceCodeVariable-Roman.otf

echo "\n* Unziping package"
mkdir -p ~/.fonts

echo "\n* Copying fonts to ~/fonts"
cp SourceCodeVariable-Roman.otf ~/.fonts/

echo "\n* Updating font cache"
sudo fc-cache -f -v

echo "\n* Looking for 'Source Code Pro' in installed fonts"
fc-list | grep "Source Code Pro"

echo "\n* Now, you can use the 'Source Code Pro' fonts, ** for sublime text ** just add the lines bellow to 'Preferences > Settings':"
echo '\n  "font_face": "Source Code Pro",'
echo '  "font_size": 10'

echo "\n* Finished :)\n"
