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
##########


echo "Please enter the ticket number: "
read cwticket
#echo "You entered: $cwticket"
echo "Please enter the user account: "
read useraccount
#echo "You entered: $useraccount"
echo "Please enter the functional area (i.e. Xray, Gamma, etc): "
read funcarea
#echo "You entered: $funcarea"
echo "Please enter the password: "
read -s password1
echo "Please enter the password again: "
read -s password2

#Verify Both passwords match
if [ $password1 != $password2]; then
	echo "Passwords do not match!"
	echo "Terminating Script!"
	exit	
else
	echo "Creating Jailed SFTP Account. Please hold."
fi

#Make backup dir
mkdir -p /opt/apparatus/backups/$cwticket

#Make a backup of current working sshd_config
cp /etc/ssh/sshd_config /opt/apparatus/backups/$cwticket

#Make change to sshd_config
cat << EO1FF >> "/etc/ssh/sshd_config"

#$useraccount ($funcarea) $cwticket \n
    Match User $useraccount
    ChrootDirectory /jail/$useraccount
    ForceCommand internal-sftp
    AllowTcpForwarding no
EO1FF

#Reload the SSHD service
service sshd reload

#Add user account
useradd -G sshusers -M -d /files $useraccount

#Create default password
password=$password1
echo "$useraccount:$password" | chpasswd

#Create File Structure
cd /jail; mkdir -p $useraccount/files/$useraccount

#Change permissions
cd $useraccount/files; chown -R $useraccount:$useraccount . ; chmod -R 770 .

#Now go test
echo "Go Test sftp $useraccount@upload"