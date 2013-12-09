# Class: mysql061::java
#
# This class installs the mysql-java-connector.
#
# Parameters:
#   [*java_package_name*]  - The name of the mysql java package.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql061::java (
  $package_name   = $mysql061::params::java_package_name,
  $package_ensure = 'present'
) inherits mysql061::params {

  package { 'mysql-connector-java':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
