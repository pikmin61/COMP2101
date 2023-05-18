#1/bin/bash

#echo text with FQDN on same line 
echo -n -e "\nFully-qualified domain name: "
hostname -f

#
echo -e "\nCurrent Host Info: "
hostnamectl


#
echo -e "\nIpv4's: "
hostname -I

#
echo -e "\n"
df
