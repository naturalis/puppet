class redis::package {

  package {'redis-server':
    ensure => present,
  }

}
