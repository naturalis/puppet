class puppetci::slave {
  include jenkins::slave
  notice("The class is: ${name}")


}
