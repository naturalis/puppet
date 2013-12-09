# Class: mysql061::config
#
# Parameters:
#
#   [*root_password*]     - root user password.
#   [*old_root_password*] - previous root user password,
#   [*bind_address*]      - address to bind service.
#   [*port*]              - port to bind service.
#   [*etc_root_password*] - whether to save /etc/my.cnf.
#   [*service_name*]      - mysql service name.
#   [*config_file*]       - my.cnf configuration file path.
#   [*socket*]            - mysql socket.
#   [*datadir*]           - path to datadir.
#   [*ssl]                - enable ssl
#   [*ssl_ca]             - path to ssl-ca
#   [*ssl_cert]           - path to ssl-cert
#   [*ssl_key]            - path to ssl-key
#   [*log_error]          - path to mysql error log
#   [*default_engine]     - configure a default table engine
#   [*root_group]         - use specified group for root-owned files
#   [*restart]            - whether to restart mysqld (true/false)
#
# Actions:
#
# Requires:
#
#   class mysql061::server
#
# Usage:
#
#   class { 'mysql061::config':
#     root_password => 'changeme',
#     bind_address  => $::ipaddress,
#   }
#
class mysql061::config(
  $root_password     = 'UNSET',
  $old_root_password = '',
  $bind_address      = $mysql061::params::bind_address,
  $port              = $mysql061::params::port,
  $etc_root_password = $mysql061::params::etc_root_password,
  $service_name      = $mysql061::params::service_name,
  $config_file       = $mysql061::params::config_file,
  $socket            = $mysql061::params::socket,
  $pidfile           = $mysql061::params::pidfile,
  $datadir           = $mysql061::params::datadir,
  $ssl               = $mysql061::params::ssl,
  $ssl_ca            = $mysql061::params::ssl_ca,
  $ssl_cert          = $mysql061::params::ssl_cert,
  $ssl_key           = $mysql061::params::ssl_key,
  $log_error         = $mysql061::params::log_error,
  $default_engine    = 'UNSET',
  $root_group        = $mysql061::params::root_group,
  $restart           = $mysql061::params::restart,
  $purge_conf_dir    = false
) inherits mysql061::params {

  File {
    owner  => 'root',
    group  => $root_group,
    mode   => '0400',
    notify    => $restart ? {
      true => Exec['mysqld-restart'],
      false => undef,
    },
  }

  if $ssl and $ssl_ca == undef {
    fail('The ssl_ca parameter is required when ssl is true')
  }

  if $ssl and $ssl_cert == undef {
    fail('The ssl_cert parameter is required when ssl is true')
  }

  if $ssl and $ssl_key == undef {
    fail('The ssl_key parameter is required when ssl is true')
  }

  # This kind of sucks, that I have to specify a difference resource for
  # restart.  the reason is that I need the service to be started before mods
  # to the config file which can cause a refresh
  exec { 'mysqld-restart':
    command     => "service ${service_name} restart",
    logoutput   => on_failure,
    refreshonly => true,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }

  # manage root password if it is set
  if $root_password != 'UNSET' {
    case $old_root_password {
      '':      { $old_pw='' }
      default: { $old_pw="-p'${old_root_password}'" }
    }

    exec { 'set_mysql_rootpw':
      command   => "mysqladmin -u root ${old_pw} password '${root_password}'",
      logoutput => true,
      unless    => "mysqladmin -u root -p'${root_password}' status > /dev/null",
      path      => '/usr/local/sbin:/usr/bin:/usr/local/bin',
      notify    => $restart ? {
        true  => Exec['mysqld-restart'],
        false => undef,
      },
      require   => File['/etc/mysql061/conf.d'],
    }

    file { '/root/.my.cnf':
      content => template('mysql061/my.cnf.pass.erb'),
      require => Exec['set_mysql_rootpw'],
    }

    if $etc_root_password {
      file{ '/etc/my.cnf':
        content => template('mysql061/my.cnf.pass.erb'),
        require => Exec['set_mysql_rootpw'],
      }
    }
  } else {
    file { '/root/.my.cnf':
      ensure  => present,
    }
  }

  file { '/etc/mysql':
    ensure => directory,
    mode   => '0755',
  }
  file { '/etc/mysql/conf.d':
    ensure  => directory,
    mode    => '0755',
    recurse => $purge_conf_dir,
    purge   => $purge_conf_dir,
  }
  file { $config_file:
    content => template('mysql061/my.cnf.erb'),
    mode    => '0644',
  }

}
