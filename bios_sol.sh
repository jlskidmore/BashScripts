# uses ipmitool to set server to boot to bios then power on/reboot server based on current power status and opens SOL console
# assumes that user and pass are "ADMIN". Later changed to get credentials from API.
# could also be changed to accept user and pass as script arguments $2, $3
ipmitool -H $1 -U ADMIN -P ADMIN  chassis bootparam set bootflag force_bios

if ipmitool -I lanplus -U ADMIN -P ADMIN chassis power status -H $1 | grep -q 'off' 
    then ipmitool -I lanplus -U ADMIN -P ADMIN chassis power on -H $1

else 
    ipmitool -I lanplus -U ADMIN -P ADMIN chassis power reset -H $1

sleep 3; ipmitool -I lanplus -U ADMIN -P ADMIN sol activate -H $1

fi
