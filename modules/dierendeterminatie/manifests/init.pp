# == Class: dierendeterminatie
#
# Full description of class dierendeterminatie here.
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
#  class { dierendeterminatie:
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
class dierendeterminatie (
  $backmeup = true,
  $backuphour = 1,
  $backupminute = 1,
  $autorestore = true,
  $restoreurl = 'http://188.142.55.189/',
  $restoreversion = 'latest',
  $backupdir = '/tmp/backups',
) {

  include concat::setup
  include apache

  # Create all virtual hosts from hiera
  class { 'dierendeterminatie::instances': }

  # Create mysql server
  include mysql::server

  file { 'backupdir':
    ensure => 'directory',
    path   => $backupdir,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }


  if $backmeup == true {
    class { 'dierendeterminatie::backmeup':
      backuphour   => $backuphour,
      backupminute => $backupminute,
    }
  }

  if $autorestore == true {
    class { 'dierendeterminatie::restore':
      url         => $restoreurl,
      version     => $restoreversion,
    }
  }
}
