stage { [pre, post]: }
Stage[pre] -> Stage[main] -> Stage[post]

class { 'puppetci':
  stage => main,
}
class { 'puppetci::build':
  stage => post,
}

