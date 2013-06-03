# Class: mysql::restore
#
# This module handles ...
#
# Parameters:
#   [*restorefile*]    - The file to import mysqldump.
#   [*database*]       - The database to restore
#
# Requires:
#   Class['mysql::config']
#
# Sample Usage:
#   class { 'mysql::restore':
#     restorefile => '/tmp/backups',
#     database    => 'mydatabase',
#   }
#
class mysql::restore (
  $restorefile = undef,
  $database = undef,
) {

  database { $database:
    ensure  => 'present',
  }

  exec { 'mysql-restore':
    command => "/usr/bin/mysql ${database} < ${restorefile}",
    require => Database[ $database ],
  }
}
