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

#  exec { 'getdata':
#    path => '/usr/local/sbin/file-restore.sh',
#  }

  file { "$name_file-restore.sh":
    path => '/usr/local/sbin/file-restore.sh',
    content => template('duplicity/file-restore.sh.erb'),
    mode    => '0755',
  }


#  class { 'mysql::restore':
#    restorefile => "${restore_directory}/linnaeus_ng.sql",
#    database    => 'linnaeus_ng',
#    require     => Exec[ 'getdata' ],
#  }
}

