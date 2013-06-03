# == Class: puppetdev
#
# Install puppet development tools.
# Clone git repo
#
# === Parameters
#
# repo (todo).
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { puppetdev:
#    repos => [ 'https://code.google.com/p/demo-puppet-repo', 'https://code.google.com/p/openstack-poc' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class puppetdev {

  include stdlib
  include git

  vcsrepo { '/root/demo-puppet-repo':
    ensure   => present,
    provider => git,
    source   => 'https://code.google.com/p/demo-puppet-repo',
  }

  package { 'rubygems':
    ensure   => installed,
    require  => Vcsrepo['/root/demo-puppet-repo'],
  }

  package { 'puppet-lint':
    ensure   => installed,
    require  => Package['rubygems'],
    provider => 'gem',
  }

  package { 'graphviz':
    ensure  => installed,
  }

  exec {'install-pre-commit-hook':
    command => '/bin/cp /root/demo-puppet-repo/private/scripts/pre-commit /root/demo-puppet-repo/.git/hooks/pre-commit',
    creates => '/root/demo-puppet-repo/.git/hooks/pre-commit',
    require => Package['puppet-lint'],
  }
}
