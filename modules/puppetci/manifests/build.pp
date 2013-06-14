class puppetci::build {
  exec { '/bin/sleep 30; /usr/bin/wget http://localhost:8080/job/PuppetCI/build -o /dev/null':
  }
}
