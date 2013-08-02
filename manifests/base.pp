stage { [pre, post]: }
Stage[pre] -> Stage[main] -> Stage[post]

class { 'repoforge':
  stage => pre,
}
class { 'base':
  stage => main,
}
class { 'motd':
  stage     => post,
  mymessage => 'Classes included: motd, base, repoforge'
}
class { 'ntp': }
