class duplicity::packages {
  # Install the packages

  case $operatingsystem {
    centos: {
      file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL6":
        owner => root, 
        group => root, 
        mode => 0444,
        source => "puppet:///modules/duplicity/RPM-GPG-KEY-EPEL6"
      }
    
      yumrepo { "epel":
        mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch',
        enabled => 1,
        gpgcheck => 1,
        gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL6",
        require => File["/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL6"]
      }
      
      package {['python-boto','python-cloudfiles','ruby-augeas','PackageKit-cron','duplicity','s3cmd']: 
          ensure 	=> present,
          require    	=> Yumrepo['epel'],
      }
     }
    redhat: {
      package {
        ['duplicity','python-boto','perl-GnuPG','python-cloudfiles','ruby-augeas','s3cmd']: ensure => present
      }
     }
    debian, ubuntu: {
      package {
        ['duplicity','python-boto','gnupg','python-rackspace-cloudfiles','libaugeas-ruby']: ensure => present
      }
    }
    default: {
      fail("Unrecognized operating system")
    }
  }
}
