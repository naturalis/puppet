class { 'motd': mymessage => 'Classes included: motd, base' }
class { '::repoforge': }
class { 'base': require => Class['::repoforge'] } 
