# basic_deploy

### This is simple script to move a site and database between two predefined servers.

##### Usage: `deploy.rb SITECODE`

##### Assumptions
* Both servers are reachable from the system on which the script is run.
* The servers are able to communicate to one another.
* Your username on both server is the same.
* The database on each server is name the same.
* The database user has the same name on each server.
* The USERNAME has the permission to `sudo service httpd restart` on the production server.
* You have keys setup, from the machine which will run this script, to each server.
* Your user on STAGING_SERVER has keys to PRODUCTION_SERVER.

##### Variables to populate
`USERNAME`
`STAGING_SERVER`
`PRODUCTION_SERVER`
`MYSQL_USER`
`MYSQL_PASSWORD`

### bash skeleton - spec
deploy.sh SITECODE
Fix rsync commands
