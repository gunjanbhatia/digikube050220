#!/bin/bash
# Init script

cd ~/
touch ~/digikube-init.log
date >> ~/digikube-init.log

if [[ -d ~/digikube/ ]]; then
	echo "Dikiguke source directory exists. Refreshing." >> ~/digikube-init.log
	cd digikube/
	git init
	if [ $? -gt 0 ]; then
		echo "Error while refreshing dikiguke source directory. Aborting." >> ~/digikube-init.log
		exit 1
	else
		echo "Refreshed dikiguke source directory." >> ~/digikube-init.log
		git pull
		if [ $? -gt 0 ]; then
			echo "Error while pulling dikiguke source directory. Aborting." >> ~/digikube-init.log
			exit 1
		else
			echo "Pulled dikiguke source directory." >> ~/digikube-init.log
		fi	
	fi	
else
	echo "Digikube source directory not available. Clonning" >> ~/digikube-init.log
	git clone -o digikube-source https://github.com/samdesh-gcp1/digikube.git
	if [ $? -gt 0 ]; then
		echo "Error while clonning dikiguke source directory. Aborting." >> ~/digikube-init.log
		exit 1
	else
		echo "Clonned dikiguke source directory." >> ~/digikube-init.log
	fi	
fi

if [[ -e ~/digikube/installer/main.sh ]]; then
	echo "Starting digikube main installation." >> ~/digikube-init.log
	~/digikube/installer/main.sh
	if [[ $? -gt 0 ]]; then
		echo "Error during Digikube installation.  Please check installation log for details." >> ~/digikube-init.log
		exit 1
	else
		echo "Completed Digikube installation.  Please check installation log for details." >> ~/digikube-init.log
	fi
else
	echo "Digikube main installer not found. Aborting." >> ~/digikube-init.log
	exit 1
fi


