class { 'motd': }
$role = hiera('role')
class { "$role":  }
