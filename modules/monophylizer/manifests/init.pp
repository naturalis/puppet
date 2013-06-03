# == Class: monophylizer
#
# This class installs the monophylizer webtool, for more information https://github.com/ncbnaturalis/monophylizer
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { monophylizer: }
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
  include concat::setup
  include apache

  package { 'perl-doc':
    ensure => present,
  }

  class { 'perl':
    require  => Package['perl-doc'],
  }

  perl::module { 'Bio::Phylo':
    require  => Package['perl-doc'],
  }

  class { 'monophylizer::instances': }

  vcsrepo { '/var/monophylizer':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/ncbnaturalis/monophylizer.git',
    require  => Class['monophylizer::instances'],
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

  file { '/var/www/monophylizer/index.html':
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
