# Parameters:
#
class dierendeterminatie::backmeup (
  $backuphour = 3,
  $backupminute = 5,
  $backupdir = '/tmp/backups',
)
{
  notify {'Backup enabled':}

  class { 'mysql::backup':
    backupuser     => 'myuser',
    backuppassword => 'mypassword',
    backupdir      => $backupdir,
    backuphour     => $backuphour,
    backupminute   => $backupminute,
  }
}
