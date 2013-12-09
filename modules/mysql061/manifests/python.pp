# Class: mysql061::python
#
# This class installs the python libs for mysql.
#
# Parameters:
#   [*ensure*]       - ensure state for package.
#                        can be specified as version.
#   [*package_name*] - name of package
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mysql061::python(
  $package_name   = $mysql061::params::python_package_name,
  $package_ensure = 'present'
) inherits mysql061::params {

  package { 'python-mysqldb':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
