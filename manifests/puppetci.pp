stage { [pre, post]: }
Stage[pre] -> Stage[main] -> Stage[post]

class { 'puppetci': }
class { 'puppetci::build':
  stage => post,
}
