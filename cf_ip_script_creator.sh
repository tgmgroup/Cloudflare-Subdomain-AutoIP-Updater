#!/bin/bash

### Purpose
# This script creates a script to read in your CloudFlare variables.
# Then this script uses those variables to create a new script to make an auto-updating script.
# Whenever you run the auto-updating script, the system will get its IP address of the system
#   and update the associated information at CloudFlare.

### Variables
#  FULLDOMAIN
#  SUBDOMAIN
#  EMAIL
#  KEY

###### 1. Create cf_ip_updater_creator.sh script (start)
sudo touch cf_ip_updater_creater.sh

##################### cf_ip_updater_creator.sh script (start)
cat << 'EOF' >> cf_ip_updater_creater.sh

# Get User Data
echo -n "Enter your FULL-DOMAIN (e.g. cloudflare.com) and press [ENTER]: "
read FULLDOMAIN

echo -n "Enter your SUB-DOMAIN (e.g. web.cloudflare.com) and press [ENTER]: "
read SUBDOMAIN

echo -n "Enter your Cloudflare Email (e.g. email@cloudflare.com) and press [ENTER]: "
read EMAIL

echo -n "Enter your Cloudflare API Key (e.g. 9a7806061c88ada191ed06f989cc3dac) and press [ENTER]: "
read KEY


echo -n "Enter path to create cf_ip_updater.sh script (e.g. /home/path) and press [ENTER]: "
read FILEPATH


# Get Zone and Record IDS
ZONEID=$(curl -X GET "https://api.cloudflare.com/client/v4/zones?name=$FULLDOMAIN" \
  -H "X-Auth-Email: $EMAIL" \
  -H "X-Auth-Key: $KEY" \
  -H "Content-Type: application/json" | jq . | grep id | head -1 | cut -d '"' -f4)

RECORDID=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records?name=$SUBDOMAIN" \
  -H "X-Auth-Email: $EMAIL" \
  -H "X-Auth-Key: $KEY" \
  -H "Content-Type: application/json" | jq . | grep id | head -1 | cut -d '"' -f4)


# Print IDS
echo "Your Zone ID:   $ZONEID"
echo "Your Record ID: $RECORDID"


###### 2. Create cf_ip_updater.sh script (start)
      FILE="$FILEPATH/cf_ip_updater.sh"
      echo "Your script name: $FILE"
      
      
      ##################### cf_ip_updater.sh script (start)
      cat << EOM >>$FILE

#!/bin/sh

[ ! -f /var/tmp/current_ip.txt ] && touch /var/tmp/currentip.txt

NEWIP=\$(dig +short myip.opendns.com @resolver1.opendns.com)
CURRENTIP=\$(cat /var/tmp/currentip.txt)

if [ "\$NEWIP" = "\$CURRENTIP" ]
then
  echo "IP address unchanged"
else
  curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records/$RECORDID" \
    -H "X-Auth-Email: $EMAIL" \
    -H "X-Auth-Key: $KEY" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$SUBDOMAIN\",\"content\":\"\$NEWIP\"}"
  echo \$NEWIP > /var/tmp/currentip.txt
fi
EOM
      ##################### cf_ip_updater.sh script (ends)
      
  chmod +x $FILE
###### 2. Create cf_ip_updater.sh script (end)

EOF
##################### cf_ip_updater_creator.sh script (end)

###### 1. Create cf_ip_updater_creator.sh script (end)



###### 3. Run cf_ip_updater_creator.sh
sudo chmod +x cf_ip_updater_creater.sh
./cf_ip_updater_creater.sh
