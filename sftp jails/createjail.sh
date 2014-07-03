#!/bin/bash

#########
# This Script Creates Jailed user accounts on Upload
# These are typically Normal Changes.
# !!!THIS REQUIRES BEING RAN AS ROOT!!!
#
# Created By: Josh Bailey
#
# Variables
# useraccount - The user account that will be logged in with
# funcarea - Team/Squad Name
# cwticket - ConnectWise Ticket for this change.
# password - Default password
# password1 & password2 - Used to verify input
#
# exit code 0 - ran succesfully
# exit code 1 - failed password
# exit code 2 - failed reload sshd
#
#
##########

#Variables
backupdir = /opt/apparatus/backups

echo "Please enter the ticket number: "
read cwticket
echo "Please enter the user account: "
read useraccount
echo "Please enter the functional area (i.e. Xray, Gamma, etc): "
read funcarea
echo "Please enter the password: "
read -s password1
echo "Please enter the password again: "
read -s password2

#Verify Both passwords match
if [ $password1 != $password2]; then
	echo "Passwords do not match!"
	echo "Terminating Script!"
	exit 1	
else
	echo "Creating Jailed SFTP Account. Please hold."
fi

#Make backup dir
mkdir -p $backupdir/$cwticket

#Make a backup of current working sshd_config
cp /etc/ssh/sshd_config $backupdir/$cwticket

#Make change to sshd_config
cat << EO1FF >> "/etc/ssh/sshd_config"

#$useraccount ($funcarea) $cwticket
    Match User $useraccount
    ChrootDirectory /jail/$useraccount
    ForceCommand internal-sftp
    AllowTcpForwarding no
EO1FF

#Reload the SSHD service
service sshd reload

#sshd exit code for restart
if [ $? != 0 ]; then
	echo "SSHD service did not reload successfully."
	echo "Rolling back sshd_config to previous version."
	cp -rf /opt/apparatus/backups/$cwticket/sshd_config /etc/ssh/sshd_config
	service sshd reload
	exit 2
fi

#Add user account
useradd -G sshusers -M -d /files $useraccount

#Create default password
password=$password1
echo "$useraccount:$password" | chpasswd

#Create File Structure
mkdir -p /jail/$useraccount/files/$useraccount

#Change permissions
chown -R $useraccount:$useraccount /jail/$useraccount/files ; chmod -R 770 /jail/$useraccount/files

#Now go test
echo "Go Test sftp $useraccount@upload"
exit 0