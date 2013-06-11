class puppetci::slave {
  include puppet-lint
  include jenkins::slave
}
