# == Class: puppetdocu
#
# Puppet documentation class, generates html documenting for puppet modules.
#
# === Parameters
#
# [*$documentdir*]
#   Specifies destination directory for documentation
#
# === Variables
#
# === Examples
#
#  class { puppetdocu:
#    $documentdir => [ '/var/www/puppetdoc' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class puppetdocu(
  $documentdir = '/etc/puppet/doc',
) {

  exec {'generate_puppetdoc':
    command => "/usr/bin/puppet doc --mode rdoc --all --modulepath /etc/puppet/modules/ --outputdir $documentdir",
    creates => "$documentdir/index.html",
  }
}
