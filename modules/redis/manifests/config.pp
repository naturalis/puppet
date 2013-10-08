class redis::config {

  file {'/etc/redis/redis.conf':
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template('redis/redis.conf.erb'),
  }

}
