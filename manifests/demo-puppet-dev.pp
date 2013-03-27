class { 'git': }
class { 'lockdown': }
class { 'motd': }

exec {'install-pre-commit-hook':
  command => '/bin/cp /root/demo-puppet-repo/private/scripts/pre-commit /root/demo-puppet-repo/.git/hooks/pre-commit',
  creates => '/root/demo-puppet-repo/.git/hooks/pre-commit',
  require => Vcsrepo['/root/demo-puppet-repo'],
}

vcsrepo { '/root/demo-puppet-repo':
  ensure   => present,
  provider => git,
  source   => 'https://code.google.com/p/demo-puppet-repo/',
}
