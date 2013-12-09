class { 'mysql061::server':
  config_hash => { 'root_password' => 'password', },
}
class { 'mysql061::server::account_security': }
