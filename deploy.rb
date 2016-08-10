#!/usr/bin/ruby
USERNAME = 'centos'
SITECODE = ARGV[0]
STAGING_SERVER = ''
PRODUCTION_SERVER = ''
MYSQL_USER = ''
MYSQL_PASSWORD = ''
USAGE = 'deploy SITECODE'

if ARGV.length != 1
  puts USAGE
  exit (1)
end

# Export the db on staging
def export_db
  result = `ssh -t #{USERNAME}@#{STAGING_SERVER} 'mysqldump -u#{MYSQL_USER} -p#{MYSQL_PASSWORD} #{SITECODE} > /tmp/#{SITECODE}.sql'`
  if $?.success?
    puts 'Database exported from staging.'
  else
    puts 'FAILED exporting database from staging'
    puts result
  exit(2)
  end
end

# Ship the db to prod
def ship_db
  result = `ssh -t #{USERNAME}@#{STAGING_SERVER} 'rsync /tmp/#{SITECODE}.sql #{USERNAME}@#{PRODUCTION_SERVER}:/tmp/#{SITECODE}.sql'`
  if $?.success?
    puts 'Database shipped to prod.'
  else
    puts 'FAILED shipping database to prod.'
    puts result
  exit(3)
  end
end

# Ship the site files to prod
def ship_site
  result = `ssh -t #{USERNAME}@#{STAGING_SERVER} 'rsync /var/www/#{SITECODE} #{USERNAME}@#{PRODUCTION_SERVER}:/var/www/#{SITECODE}'`
  if $?.success?
    puts 'Site files shipped to prod.'
  else
    puts 'FAILED shipping site files to prod.'
    puts result
  exit(4)
  end
end

# Import the db on prod
def import_db
  result = `ssh -t #{USERNAME}@#{STAGING_SERVER} 'mysql -u#{USERNAME} -p#{MYSQL_PASSWORD} #{SITECODE} < /tmp/#{SITECODE}.sql'`
  if $?.success?
    puts 'Database imported into prod.'
  else
    puts 'FAILED importing db on prod.'
    puts result
  exit(5)
  end
end

# Bounce the service on prod
def bounce_httpd 
  result = `ssh -t #{USERNAME}@#{PRODUCTION_SERVER} 'sudo service httpd restart'`
  if $?.success?
    puts 'Bounced webserver on prod.'
  else
    puts 'FAILED bouncing webserver on prod'
    puts result
  exit(6)
  end
end
  
# Main
export_db
ship_db
ship_site
import_db
bounce_httpd
