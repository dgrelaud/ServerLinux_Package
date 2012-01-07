#***********************************************************************#
#                     INSTALL YII FRAMEWORK AND PHPMYADMIN                               
#                     ------------------------------------                               
#
# To activate the site, you must reload nginx yourself
#                                                                       
#***********************************************************************#

echo "----- Enter the parameters ------";
### get IP address and the name of the application ####
echo "What is the IP of this server (ex. : 198.54.14.54) ?"
read  vHostIpAddress
echo "What is the DNS name of PHPMyAdmin (ex. : acme.ideolys.net) ?" 
read  domainName
echo "Define a password for PhpMyAdmin ?" 
read  phpMyAdminPassword
echo "";

### Create the Nginx config file for phpmyadmin
cd nginx/site-available-template/
cp phpmyadmin-app $domainName
sed -i "s/_VHOST_IP_ADDRESS_/$vHostIpAddress/g" $domainName
sed -i "s/_VHOST_DOMAIN_NAME_/$domainName/g" $domainName
sed -i "s/_APPLICATION_NAME_/phpmyadmin/g" $domainName

mv $domainName /etc/nginx/sites-available/

### Copy phpmyadmin, yii framework and default
cd ../../www/
cp -R . /var/www/

### Change owner of files to www-data (user of Nginx Server)
cd /var/www
chown -R www-data:www-data .
cd phpmyadmin/
mv config.sample.inc.php config.inc.php
### Change password of phpmyadmin
sed -i "s/_PHPMYADMIN_PASSWORD_/$phpMyAdminPassword/g" config.inc.php

### Create a symbolic link to phpmyadmin
cd /etc/nginx/sites-enable/
ln -s ../sites-available/$domainName

### Create the application name log directory
cd /var/log/nginx/
mkdir phpmyadmin
