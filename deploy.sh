#!/bin/sh
username="centos"
sitecode=$1
staging_server=""
production_server=""
mysql_user=""
mysql_password=""

function export_db {
#Export the db on staging
#Remember that, ssh -t means to execute the command delimited by apostrophes on the remote machine
ssh -t $username@$staging_server 'mysqldump -u$mysql_user -p$mysql_password $sitecode > /tmp/$sitecode.sql' 
}

function ship_db {
#Ship the db to prod
ssh -t $username@$staging_server 'rsync /tmp/$sitecode.sql $username@$production_server:/tmp/$sitecode.sql'
}

function ship_site {
#Ship the site to prod
ssh -t $username@$staging_server 'rsync /var/www/$sitecode $username@$production_server:/var/www/$sitecode'
}

function import_db {
#Import the db on prod
ssh -t $username@$production_server 'mysql -u$mysql_user -p$mysql_password $sitecode < /tmp/$sitecode.sql'
}

function bounce_httpd {
#Bounce the service on prod
ssh -t $username@$production_server 'sudo service httpd restart'
}

#Main
export_db
ship_db
ship_site
import_db
bounce_httpd
