#!/bin/bash
# Johnny5ive's Debian/Ubuntu/Mint setup script. 

# Text color variables
und=$(tput sgr 0 1)          		# Underline
bold=$(tput bold)            		# Bold
red=${txtbld}$(tput setaf 1)    # Red
reset=$(tput sgr0)              # Reset

sudo -k

echo -e $red$bold"Starting script. Let's begin!\n"$reset

echo -e $red'Creating directories\n'$reset
mkdir ~/usr
mkdir ~/.themes

# Downloading required files.
echo -e $red$bold"Downloading pre-requisite files.\n"$reset

echo -e $red'\nDownloading Ubuntu Tweak'
wget -c "https://launchpad.net/ubuntu-tweak/0.7.x/0.7.3/+download/ubuntu-tweak_0.7.3-1~precise1_all.deb"

echo -e $red'\nDownloading themes'
wget -c http://www.deviantart.com/download/288398137/omg_suite_by_nale12-d4rpdfd.zip

echo -e $red'\nInstalling themes.'
unzip -q -o omg_suite_by_nale12-d4rpdfd.zip -d ~/.themes
echo -e $red'Themes installed! Select them in settings.'

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
 	# 64-bit stuff here
 	echo -e $red'\nDownloading ATI drivers'
	wget -c http://www2.ati.com/drivers/linux/amd-driver-installer-12-8-x86.x86_64.zip
	unzip amd-driver-installer-12-8-x86.x86_64.zip\
	chmod +x amd-driver-installer-8.982-x86.x86_64.run
	mv amd-driver-installer-8.982-x86.x86_64.run amd-driver-installer.run

 	echo -e $red'\nDownloading Chrome'
	wget -cO chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

	echo -e $red'\nDownloading Sublime Text'
	wget -c "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1%20x64.tar.bz2"
	tar -xf "Sublime Text 2.0.1 x64.tar.bz2"

	echo -e $red'\nDownloading Dropbox'
	wget -cO dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.4.0_amd64.deb"
else
	# 32-bit stuff here
	echo -e $red'\nDownloading Chrome'
	wget -cO chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb"

	echo -e $red'\nDownloading Sublime Text'
	wget -c "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1.tar.bz2"
	tar -xf "Sublime Text 2.0.1.tar.bz2"

	echo -e $red'\nDownloading Dropbox'
	wget -cO dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.4.0_i386.deb"
fi

sudo sh <<SCRIPT

echo -e $red'\nAdding new repositories'
sudo add-apt-repository ppa:bimsebasse/cinnamonextras
sudo add-apt-repository ppa:pinta-maintainers/pinta-stable
sudo apt-get update 

echo -e $red'\nInstalling initial libraries and software'
sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config vlc skype pidgin wallch xchat unrar unzip openjdk-6-jdk openjdk-6-jre gnome-tweak-tool python-compizconfig prelink python-gpgme deluge deluged mosh wine pinta graphviz python-lxml gir1.2-unique-3.0

# Ubuntu Tweak
echo -e $red'\nInstalling Ubuntu Tweak'
sudo dpkg -i ubuntu-tweak_0.7.3-1~precise1_all.deb

# Chrome
echo -e $red'\nInstalling Google Chrome'
sudo dpkg -i chrome.deb

# Dropbox
echo -e $red'\nInstalling Dropbox'
sudo dpkg -i "dropbox.deb" 
echo -e $red'\nFixing Dropbox monitoring limit'
echo -e $red fs.inotify.max_user_watches=100000 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p

# Sublime Text 2
echo -e $red'\nInstalling Sublime'
sudo mv Sublime\ Text\ 2 /opt/
sudo ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
sudo sed -i 's/gedit.desktop/sublime.desktop/g' /usr/share/applications/defaults.list

echo -e $red '\nPaste step 4'
sudo mv sublime.desktop /usr/share/applications/sublime.desktop

# PreLinker
echo -e $red'\nSetting up PreLinker'
sudo sed -i 's/PRELINKING=unknown/PRELINKING=yes/g' /etc/default/prelink
sudo /etc/cron.daily/prelink
sudo touch /etc/apt/apt.conf
echo -e $red "DPkg:ost-Invoke {\"echo -e $red Running prelink, please wait...;/etc/cron.daily/prelink\";}" >> /etc/apt/apt.conf

SCRIPT

sudo -k

# Start Dropbox
echo -e $red'\nStarting Dropbox'
dropbox start -i

# Git
echo -e $red'\nSetting up Git'
git config --global user.email "code@morganhein.com"
git config --global user.name "Morgan Hein"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'

echo -e $red$bold"\Executing Rails Setup\n"$reset
git clone https://github.com/johnny5ive/Rails-Setup.git 
chmod +x Rails-Setup/RailsSetup.sh
./Rails-Setup/RailsSetup.sh

echo -e $red$bold"\Script Completed!\n"$reset