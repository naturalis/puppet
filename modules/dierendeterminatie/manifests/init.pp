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
  $version = 'latest',
  $backupdir = '/tmp/backups',
  $restore_directory = '/tmp/restore',
  $bucket = 'dierendeterminatie-testbackup',
  $dest_id = undef,
  $dest_key = undef,
  $cloud = 'cf',
  $pubkey_id = undef,
  $full_if_older_than = undef,
  $remove_older_than = undef,
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
      backuphour         => $backuphour,
      backupminute       => $backupminute,
      backupdir          => $backupdir,
      bucket             => $bucket,
      dest_id            => $dest_id,
      dest_key           => $dest_key,
      cloud              => $cloud,
      pubkey_id          => $pubkey_id,
      full_if_older_than => $full_if_older_than,
      remove_older_than  => $remove_older_than,
    }
  }

  if $autorestore == true {
    class { 'dierendeterminatie::restore':
      version     => $restoreversion,
      bucket             => $bucket,
      dest_id            => $dest_id,
      dest_key           => $dest_key,
      cloud              => $cloud,
      pubkey_id          => $pubkey_id,
    }
  }
}
