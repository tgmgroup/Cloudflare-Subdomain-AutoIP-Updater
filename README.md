# Cloudflare-Subdomain-AutoIP-Updater
Create a private Dynamic DNS using the CloudFlare API with this script.

If you have a domain registered at CloudFlare, you can use this script to update the IP of the subdomain with a specific computer. The computer will get its IP address and send the information to CloudFlare using the API.

This script creates 3 files: 
1. an initializing script that creates and runs everything: cf_ip_script_creator.sh
2. a script that gets all the CF details from you cf_ip_updater_creator.sh
3. a script that updates the subdomain IP address: cf_ip_updater.sh

Put the 3rd script (*cf_ip_updater.sh*) into a cron job to run every 5 or 15 minutes or so so that you can use access your system anywhere.

### Potential uses:
* log into your computer anytime with SSH
* run a portable OpenVPN server
* keep your blog server private by using CloudFlare caching
* whatever you can think of

### Some potential issues:
* if you fail to successfully run the script, the *cat* commands that append text to existing commands will force you to delete the create scripts (*cf_ip_updater.sh, cf_ip_updater_creator.sh*) before you run the initializing script (*cf_ip_script_creator.sh*) again.

## You need the following information: 
* FULLDOMAIN   cloudflare.com (your registered domain name)
* SUBDOMAIN    web.cloudflare.com (your subdomain linked to your system's IP address)<br>
* EMAIL        email@cloudflare.com (your account name)
* KEY          9a7806061c88ada191ed06f989cc3dac (your CloudFlare API key details)
* FILEPATH     /home/path (where you want the script to be)

## How to run:
1. wget https://raw.githubusercontent.com/tgmgroup/Cloudflare-Subdomain-AutoIP-Updater/master/cf_ip_script_creator.sh
2. chmod +X cf_ip_script_creator.sh
3. sudo bash cf_ip_script_creator.sh

## Dependencies: 
* The jq command requires the jq package (*sudo apt install jq*)
* The dig command requires dnsutils (Debian) or bind-utils (Cent-OS) (*sudo apt install dnsutils*)

## Read more at:
* https://www.georgeliu.me/2016/07/27/pivpn-staticdynamic-server-names-and-cloudflare-dns-part-1/
* https://www.georgeliu.me/2016/07/27/pivpn-staticdynamic-server-names-and-cloudflare-dns-part-2/
* https://www.georgeliu.me/2016/12/28/pivpn-staticdynamic-server-names-and-cloudflare-dns-part-3/
* http://torb.at/cloudflare-dynamic-dns (the base script creator, but I think the site is down)
