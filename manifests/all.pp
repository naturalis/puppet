stage { [pre, post]: }
Stage[pre] -> Stage[main] -> Stage[post]

class { 'stdlib': }
class { 'git': }
class { 'puppetdev': }
class { 'dierendeterminatie': }
class { 'monophylizer': }
class { 'puppetdocu': }

class { 'puppetci':
  stage => pre,
}

class { 'puppetci::build':
  stage => post,
}

class { 'motd':
  mymessage => 'Classes included:
      stdlib, git, puppetdev,
      dierendeterminatie, monophylizer,
      puppetdocu, puppetci, motd'
  }
