# Class: mysql061::ruby
#
# installs the ruby bindings for mysql
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
class mysql061::ruby (
  $package_name     = $mysql061::params::ruby_package_name,
  $package_provider = $mysql061::params::ruby_package_provider,
  $package_ensure   = 'present'
) inherits mysql061::params {

  package{ 'ruby_mysql':
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
  }

}
