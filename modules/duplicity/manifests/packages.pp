class duplicity::packages {
  # Install the packages
  package {
    ['duplicity', 'python-boto', 'gnupg', 'python-rackspace-cloudfiles']: ensure => present
  }
}
