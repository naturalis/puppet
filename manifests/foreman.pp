Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }
$puppetmaster = 'foreman.naturalis.nl'

class { '::puppet': }
class { '::puppet::server': }

class  { 'foreman':
  foreman_url     => $puppetmaster,
  unattended      => true,
  db_type         => 'mysql',
  oauth_map_users => false,
  require         => Class[ '::puppet', '::puppet::server' ],
}

class  { 'foreman_proxy':
  register_in_foreman => true,
  ssl_key             => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  ssl_cert            => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  ssl_ca              => "/var/lib/puppet/ssl/certs/ca.pem",
  ssldir              => "/var/lib/puppet/ssl",
  require             => Class[ 'foreman' ],
}

exec { 'gen_puppet_keys':
  command => 'puppet agent --test --noop; sleep 5; /usr/sbin/puppetdb-ssl-setup -f; service puppetdb restart',
  require => Class[ '::puppet', '::puppet::server', 'foreman_proxy' ],
}

exec { 'enable_puppet':
  command => 'sed -i "s/START=no/START=yes/g" /etc/default/puppet',
  unless  => 'grep "START=yes" /etc/default/puppet',
  notify  => Service[ 'puppet' ],
  require => [ Exec[ 'gen_puppet_keys' ], Class[ 'Puppetdb::Master::Puppetdb_conf' ] ],
}

package { 'foreman-compute':
  ensure  => installed,
  require => Class[ 'foreman' ],
}

class { 'puppetdb::master::config':
  require => Exec[ 'gen_puppet_keys' ],
}

exec { 'disable apache decode':
  command => 'a2dismod deflate',
  require => Class[ 'foreman' ],
}


class { 'puppetdb':
  ssl_listen_address => '0.0.0.0',
  listen_address     => '0.0.0.0',
  require            => Class[ 'puppetdb::master::config' ],
  notify             => Service[ 'puppet' ],
}

package { 'iptables-persistent':
  ensure => present,
}

firewall { "000 accept all icmp requests":
  proto => "icmp",
  action => "accept",
  require => Package['iptables-persistent']
}

firewall { '100 allow ssh access':
  port => [22],
  proto => tcp,
  action => accept,
  require => Package['iptables-persistent']
}

firewall { '200 allow http and https access':
  port => [80, 443],
  proto => tcp,
  action => accept,
  require => Package['iptables-persistent']
}

firewall { '210 allow clients to puppetmaster access':
  port => [8140],
  proto => tcp,
  action => accept,
  require => Package['iptables-persistent']
}

resources { 'firewall':
  purge => true,
  require => Package['iptables-persistent']
}


