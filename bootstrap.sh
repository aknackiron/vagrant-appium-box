#!/usr/bin/env bash

case $(id -u) in
    0)
	sudo apt-get update
	sudo apt-get -y install unzip curl python-software-properties git apt-utils debconf-utils software-properties-common
        # install nodejs
	curl -sL https://deb.nodesource.com/setup_7.x | sudo bash -
	sudo apt-get -y install nodejs
        sudo add-apt-repository -y ppa:webupd8team/java
        sudo apt-get update
        echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
        sudo apt-get install -y oracle-java8-installer

        # gpg for RVM, installation done as normal user
	gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
	echo "End of ROOT commands, calling script again as 'vagrant' user..."

        # continue this script as normal user
	sudo -u vagrant -i $0
	;;
    *)
        # @TODO why Ruby & RVM installation?
        # finish RVM installation
        curl -sSL https://get.rvm.io | bash -s stable --ruby
	source /home/vagrant/.rvm/scripts/rvm
	# echo "export PATH=/home/vagrant/.rvm/scripts/rvm:$PATH" >> ~/.bashrc
	export "PATH=/home/vagrant/.rvm/scripts/rvm:$PATH"
        
	## Ruby
	gem install --no-rdoc --no-ri bundler appium_console
	gem cleanup
	
	##################################################################################################
	# Node
	##################################################################################################
	
	# Enable npm to be used without sudo & install appium with it
	npm config set prefix ~/npm
	npm install -g grunt grunt-cli appium appium-doctor
        
	# Add ~/npm/bin to the PATH variable
	export "PATH=$HOME/npm/bin:$PATH"
        
	##################################################################################################
	# ADT
	##################################################################################################

        TOOLS="tools_r25.2.3-linux"
	# Download ADT
        if [ -e "$TOOLS" ]; then
            echo "Android Debug tools already downloaded"
        else
	    curl -O "https://dl.google.com/android/repository/$TOOLS.zip"
	    # Extract ADT archive 
	    unzip -q "$TOOLS.zip"
	    # Define new ANDROID_HOME env var inside .bashrc
	    #echo "export ANDROID_HOME=$HOME/tools" >> ~/.bashrc
            export "ANDROID_HOME=$HOME/tools"
            export "PATH=$PATH:$ANDROID_HOME:$ANDROID_HOME/bin"
            
            # ADB -- TODO: needs user interaction on first run!
            yes | sdkmanager "tools"
            yes | sdkmanager "platforms;android-25"
            sdkmanager --update

            # update PATH to include platform-tools dir with adb
            export "PATH=$PATH:$HOME/platform-tools"
        fi

        # Update .bashrc with all env variables
        echo "$PATH" >> ~/.bashrc
        
	##################################################################################################
	# Ant - NOT NEEDED if not installing appium from source
	##################################################################################################

	# Download ant
	# curl -O http://mirror.netinch.com/pub/apache//ant/binaries/apache-ant-1.10.1-bin.tar.gz

	# # Extract ant
	# tar -zxvf apache-ant-1.10.1-bin.tar.gz 

	# # Add ant/bin to the PATH variable
	# echo "export PATH=$HOME/apache-ant-1.9.4/bin:$PATH" >> ~/.bashrc
	# # Execute the .bashrc file
	# export PATH=$HOME/apache-ant-1.9.4/bin:$PATH

	##################################################################################################
	# Enable USB devices
	##################################################################################################

	# Samsung Galaxy
	sudo cp /vagrant/android.rules /etc/udev/rules.d/51-android.rules
	sudo chmod 644   /etc/udev/rules.d/51-android.rules
	sudo chown root. /etc/udev/rules.d/51-android.rules
	sudo service udev restart
	sudo killall adb
	
	##################################################################################################
	# Appium - from source
	##################################################################################################
        # Install Appium from source
	# # # Clone Appium
	# APPIUM_DIR="$HOME/appium"
        # echo "Get Appium"
	# if [ -e "$APPIUM_DIR" ]; then
	#     echo "Appium directory exists, pulling possible updates"
	#     cd "$APPIUM_DIR"
	#     git pull
	# else 
	#     git clone https://github.com/appium/appium.git "$APPIUM_DIR"
	# fi

	# # Change to the appium directory
	# cd "$APPIUM_DIR"

	# # Reset appium
	# # Running the reset.sh script doesn't seem to work correctly via the script.
	# # This could be fixed with some TLC.
	# echo "Reset Appium"
	# ./reset.sh --android

	##################################################################################################
	# Copy node init script to /etc/init.d/
	##################################################################################################
	echo "Copying node init script to /etc/init.d/ and creating start symlink to it"
	INIT_SCRIPT="/etc/init.d/node-service.sh"
	sudo cp /vagrant/node-init.sh "$INIT_SCRIPT"
	sudo chmod 775 "$INIT_SCRIPT" 
	sudo update-rc.d node-init.sh defaults

	##################################################################################################
	# Launching VM 
	##################################################################################################

	echo "################################################################"
	echo "Bootstrap finished:"
	echo " > Please run 'vagrant ssh' to launch VM"
	echo "################################################################"

	##################################################################################################
	# Connecting USB devices 
	##################################################################################################

	echo "USB Device setup:"
	echo " > Please connect your device via USB"
	echo " > 'adb devices' "
	echo "################################################################"
	

	echo "End of vagrant user commands"
	;;
esac
