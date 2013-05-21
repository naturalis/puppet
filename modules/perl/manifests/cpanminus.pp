# Class: perl::cpanminus
#
# This class installs cpanminus fetching it directly
#
class perl::cpanminus inherits perl {

  package{ 'curl':
    ensure => installed,
  }

  package{ 'make':
    ensure => installed,
  }

  exec{ 'install_cpanminus':
    path    => ['/usr/bin/','/bin'],
    command => 'curl -L http://cpanmin.us | perl - App::cpanminus',
    unless  => 'perldoc -l App::cpanminus',
    timeout => 600,
    require => Package['curl', 'make'],
  }

}
