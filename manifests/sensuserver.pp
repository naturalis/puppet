class { 'redis': }
class { 'sensu': }
class { 'motd': mymessage => 'Classes included: sensu,redis, motd' }
