class { 'git': }
class { 'lockdown': }
class { 'motd': }

exec {'get_demo-puppet-repo':
  command => '/usr/bin/git clone https://code.google.com/p/demo-puppet-repo/ /root/demo-puppet-repo',
  creates => '/root/demo-puppet-repo',
}

exec {'install-pre-commit-hook':
  command => '/bin/cp /root/demo-puppet-repo/private/scripts/pre-commit /root/demo-puppet-repo/.git/hooks/pre-commit',
  creates => '/root/demo-puppet-repo/.git/hooks/pre-commit',
  require => Exec['get_demo-puppet-repo'],
}
