# Create apache server
class { 'apache': }

# Create all virtual hosts from hiera
create_resources('apache::vhost', hiera('monophylizer', []))

  vcsrepo { '/var/monophylizer':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/ncbnaturalis/monophylizer.git',
  }

  file { '/var/monophylizer/script/monophylizer.pl':
    ensure  => 'file',
    mode    => '755',
  }

  file { '/usr/lib/cgi-bin/monophylizer.pl':
    ensure => 'link',
    mode   => '777',
    target => '/var/monophylizer/script/monophylizer.pl',
  }

  file { '/var/www/monophylizer/monophylizer.html':
    ensure => 'link',
    mode   => '644',
    target => '/var/monophylizer/html/monophylizer.html',
  }

  file { '/var/www/monophylizer/sorttable.js':
    ensure => 'link',
    mode   => '644',
    target => '/var/monophylizer/script/sorttable.js',
  }

