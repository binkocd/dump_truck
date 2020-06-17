#!/bin/bash

if [ "$1" = "" ]
then
        echo
        echo "Usage: $0 USERNAME"
        echo
        echo "Example:  $0 kam"
        echo

        exit 1
fi

Username=`cat /etc/passwd | grep -Ew ^$1 | cut -d":" -f1`

if [ "$Username" = "" ]
then
        echo "Username $1 doesn't exist"
        exit 2
fi

Userid=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f3`
UserPrimaryGroupId=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f4`
UserPrimaryGroup=`cat /etc/group | grep :"$UserPrimaryGroupId": | cut -d":" -f1`
UserInfo=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f5`
UserHomeDir=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f6`
UserShell=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f7`
UserGroups=`groups $Username | awk -F": " '{print $2}'`
PasswordExpiryDate=`chage -l $Username | grep "Password expires" | awk -F": " '{print $2}'`
LastPasswordChangeDate=`chage -l $Username | grep "Last password change" | awk -F": " '{print $2}'`
AccountExpiryDate=`chage -l $Username | grep "Account expires" | awk -F": " '{print $2}'`
HomeDirSize=`du -hs $UserHomeDir | awk '{print $1}'`

echo
printf "%-25s : %5s  [User Id - %s]\n" "Username" "$Username" "$Userid"
printf "%-25s : %5s\n" "User Info" "$UserInfo"
echo
printf "%-25s : %5s  [Group Id - %s]\n" "User's Primary Group" "$UserPrimaryGroup" "$UserPrimaryGroupId"
printf "%-25s : %5s\n" "User is Member of Groups" "$UserGroups"
echo
printf "%-25s : %5s  [Size Occupied - %s]\n" "Home Directory" "$UserHomeDir" "$HomeDirSize"
printf "%-25s : %5s\n" "Default Shell" "$UserShell"
echo
printf "%-25s : %5s\n" "Last Password Changed On" "$LastPasswordChangeDate"
printf "%-25s : %5s\n" "Password Expiry Date" "$PasswordExpiryDate"
printf "%-25s : %5s\n" "Account Expiry Date" "$AccountExpiryDate"
echo
