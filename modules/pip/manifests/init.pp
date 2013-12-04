# Class: pip
# Edgar Magana (eperdomo@cisco.com)
#
# This class installs pip
#
# Actions:
# - Install the pip package
#
# Sample Usage of this class:
# class { 'pip': }
#
class pip {

    package { "python-pip":
       name => "python-pip",
       ensure => "installed",
    }
}
