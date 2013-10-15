class redis(
  $port = 6379
) {

  class {'redis::package':
    notify  => Class['redis::service'],
  }

  class {'redis::config':
    notify  => Class['redis::service'],
    require => Class['redis::package'],
  }

  class {'redis::service':
    require => Class['redis::config'],
  }


}
