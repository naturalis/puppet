class { 'git': }
class { 'lockdown': }
class { 'motd': }

exec {'get_puppetdoc':
  command => '/usr/bin/git clone https://code.google.com/p/demo-puppet-repo/ /root/demo-puppet-repo',
  creates => '/root/demo-puppet-repo',
}
