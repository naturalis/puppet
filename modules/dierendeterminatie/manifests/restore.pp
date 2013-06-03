# Parameters:
#
class dierendeterminatie::restore (
  $version = undef,
  $url = undef,
  $backupdir = '/tmp/backups/',
)
{
  notify {'Restore enabled':}

  package { 'unzip':
    ensure => installed,
  }

  fetchfile{ 'fetchdb':
    downloadurl     => "${url}${version}",
    downloadfile    => $version,
    downloadto      => $backupdir,
    desintationpath => $backupdir,
    destinationfile => 'linnaeus_ng_database.sql',
    compression     => 'zip',
    require         => Package[ 'unzip' ],
  }

  class { 'mysql::restore':
    restorefile => "${backupdir}/linnaeus_ng_database.sql",
    database    => 'linnaeus_ng',
    require     => Fetchfile[ 'fetchdb' ],
  }
}

