class puppetci::build {

  exec { '/usr/bin/wget http://localhost:8080/job/PuppetCI/build -o /dev/null':
  }
}
