# Parameters:
#
class dierendeterminatie::restore (
  $version = undef,
  $restore_directory = '/tmp/restore/',
  $bucket = undef,
  $dest_id = undef,
  $dest_key = undef,
  $cloud = undef,
  $pubkey_id = undef,
)
{
  notify {'Restore enabled':}

  package { 'unzip':
    ensure => present,
  }

  duplicity::restore { 'a_restore':
    directory      => $restore_directory,
    bucket         => $bucket,
    dest_id        => $dest_id,
    dest_key       => $dest_key,
    cloud          => $cloud,
    pubkey_id      => $pubkey_id,
    post_command   => '/usr/local/sbin/mysqlbackup.sh',
  }


#  exec { 'getdata':
#    path => '/usr/local/sbin/file-restore.sh',
#  }


#  class { 'mysql::restore':
#    restorefile => "${restore_directory}/linnaeus_ng.sql",
#    database    => 'linnaeus_ng',
#    require     => Exec[ 'getdata' ],
#  }
}

