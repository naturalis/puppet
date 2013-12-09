class { 'mysql061::server':
  config_hash => {'root_password' => 'password'}
}
class { 'mysql061::backup':
  backupuser     => 'myuser',
  backuppassword => 'mypassword',
  backupdir      => '/tmp/backups',
}
