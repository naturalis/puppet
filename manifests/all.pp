class { 'stdlib': }
class { 'git': }
class { 'puppetdev': }
class { 'dierendeterminatie': }
class { 'monophylizer': }
class { 'puppetdocu': }
class { 'puppetci': }
class { 'motd':
  mymessage => 'Classes included:
      stdlib, git, puppetdev,
      dierendeterminatie, monophylizer,
      puppetdocu, puppetci, motd'
  }
