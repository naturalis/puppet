# Create apache server, enable php and rewrite mod's
class { 'apache': }
class { 'apache::mod::php': }
class { 'apache::mod::rewrite': }

# Create all virtual hosts from hiera
create_resources('apache::vhost', hiera('virtualhosts', []))

# Create mysql server
class { 'mysql::server': }

# Crontab example
cron { 'puppet':
  ensure  => present,
  command => '/usr/bin/puppet apply --logdest syslog /etc/puppet/manifests/lamp.pp > /dev/null 2>&1',
  user    => 'root',
  minute  => 30,
}
