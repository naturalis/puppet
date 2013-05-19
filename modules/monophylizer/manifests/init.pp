# == Class: monophylizer
#
# Full description of class monophylizer here.
#
# === Parameters
#
# Document parameters here.
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
#  class { monophylizer:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
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
class monophylizer {
  package { 'perl-doc':
    ensure => present,
  }

  class { 'perl':
    require  => Package['perl-doc'],
  }

  perl::module { 'Bio::Phylo':
    require  => Package['perl-doc'],
  }

  class { 'concat::setup': }
  class { 'apache': }
  class { 'apache::mod::cgi': }

  class { 'monophylizer::instances':
    require => File['/var/www', '/var/log/apache2'],
  }

  vcsrepo { '/var/monophylizer':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/ncbnaturalis/monophylizer.git',
    require  => Class['monophylizer::instances'],
  }

  file { '/var/www':
    ensure  => 'directory',
    mode    => '0755',
  }

  file { '/var/log/apache2':
    ensure  => 'directory',
    mode    => '0755',
  }

  file { '/var/monophylizer/script/monophylizer.pl':
    ensure  => 'file',
    mode    => '0755',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/usr/lib/cgi-bin/monophylizer.pl':
    ensure  => 'link',
    mode    => '0777',
    target  => '/var/monophylizer/script/monophylizer.pl',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/var/www/monophylizer/monophylizer.html':
    ensure  => 'link',
    mode    => '0644',
    target  => '/var/monophylizer/html/monophylizer.html',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/var/www/monophylizer/sorttable.js':
    ensure  => 'link',
    mode    => '0644',
    target  => '/var/monophylizer/script/sorttable.js',
    require => Vcsrepo['/var/monophylizer'],
  }
}
