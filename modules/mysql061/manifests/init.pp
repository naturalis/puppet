# Class: mysql
#
#   This class installs mysql client software.
#
# Parameters:
#   [*client_package_name*]  - The name of the mysql client package.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql (
  $package_name   = $mysql061::params::client_package_name,
  $package_ensure = 'present'
) inherits mysql061::params {

  package { 'mysql_client':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
