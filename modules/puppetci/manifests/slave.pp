class puppetci::slave {
  include puppet_lint
  include jenkins::slave
}
