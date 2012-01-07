############################################################################
# Note perso :
# To push a new config on Git:
# git add .
# git commit -m "message"
# git push -u origin master
############################################################################

#***********************************************************************#
#                     SETUP A NEW YII APPLICATION                               
#                     ---------------------------                               
# This script will 
# - create automatically the directory of the application in /var/www and 
# - create a new script for nginx in  nginx/site-available and
# - create a symbolic link in nginx/site-enable and
# - create a directory for logs in /var/log/nginx/_name_of_the_application 
#
# To activate the site, you must reload nginx yourself
#                                                                       
#***********************************************************************#

echo "----- Enter the parameters ------";
### get IP address and the name of the application ####
echo "What is the IP of this server (ex. : 198.54.14.54) ?"
read  vHostIpAddress
echo "What is the DNS name of the application (ex. : acme.ideolys.net) ?" 
read  domainName
echo "What is the name of the application. It will be used to create a directory in /var/www/@Application_name@ ?" 
read  applicationName
echo " ";

### Create the Nginx config file, replace some text in the nginx's config template 
cd nginx/site-available-template/
cp yii-app $domainName
sed -i "s/_VHOST_IP_ADDRESS_/$vHostIpAddress/g" $domainName
sed -i "s/_VHOST_DOMAIN_NAME_/$domainName/g" $domainName
sed -i "s/_APPLICATION_NAME_/$applicationName/g" $domainName

mv $domainName /etc/nginx/sites-available/

### Create a symbolic link
cd /etc/nginx/sites-enabled/
ln -s ../sites-available/$domainName

### Create the application name directory
cd /var/www/
mkdir $applicationName

### Create the application name log directory
cd /var/log/nginx/
mkdir $applicationName
