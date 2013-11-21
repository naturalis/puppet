Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

$puppetmaster = 'foreman.naturalis.nl'

package { 'puppet':
  ensure => installed;
}

exec { 'addforeman':
  command => "echo '    server=$puppetmaster' >> /etc/puppet/puppet.conf",
  unless  => "grep 'server=$puppetmaster' /etc/puppet/puppet.conf",
  require => Package [ 'puppet' ],
}

exec { 'enablepuppet':
  command => "sed -i 's/START=no/START=yes/g' /etc/default/puppet",
  unless  => "grep 'START=yes' /etc/default/puppet",
  require => Exec [ 'addforeman' ],
}

service { 'puppet':
  ensure  => running,
  require => Exec [ 'enablepuppet' ],
}

