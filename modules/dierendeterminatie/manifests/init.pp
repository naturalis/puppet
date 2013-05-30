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
  $packages = 'httpd',
) {

  # class { 'concat::setup': }
  include concat::setup
  # Create apache server, enable php and rewrite mod's
  include apache
  # class { 'apache': }

  # Create all virtual hosts from hiera
  class { 'dierendeterminatie::instances':
#    require => File['dierendeterminatie_htmlroot', 'dierendeterminatie_logdir'],
  }

  # Create mysql server
  # class { 'mysql::server': }
  include mysql::server

#  file { 'dierendeterminatie_htmlroot':
#    ensure  => 'directory',
#    mode    => '0755',
#    path    => '/var/www',
#  }

#  file { 'dierendeterminatie_logdir':
#    ensure  => 'directory',
#    mode    => '0755',
#    path    => '/var/log/apache2',
#  }

  if $backmeup == true {
    class { 'dierendeterminatie::backmeup':
      backuphour   => $backuphour,
      backupminute => $backupminute,
    }
  }
}
