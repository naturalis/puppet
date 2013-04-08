class { 'motd': }
$role = hiera('role')
include $role
