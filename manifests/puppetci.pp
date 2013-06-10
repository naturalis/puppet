stage { [pre, post]: }
Stage[pre] -> Stage[main] -> Stage[post]

class { 'puppetci':
  stage => pre,
}
class { 'puppetci::build':
  stage => post,
}
