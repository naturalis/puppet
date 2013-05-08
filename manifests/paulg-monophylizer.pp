  
class { 'monophylizer': }


# Create all virtual hosts from hiera
class monophylizer::instances
{
  create_resources('apache::vhost', hiera('monophylizer', []))
}

class monophylizer
{
  class { 'perl': }
  perl::module { 'Bio::Phylo': }
  class { 'apache': }
  class { 'apache::mod::cgi': }

  class { 'monophylizer::instances':
    require => File['/var/www', '/var/log/apache2'],
  }

  vcsrepo { '/var/monophylizer':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/ncbnaturalis/monophylizer.git',
    require => Class['monophylizer::instances'],
  }

  file { '/var/www':
    ensure  => 'directory',
    mode    => '0755',
  }

  file { '/var/log/apache2':
    ensure  => 'directory',
    mode    => '0755',
  }

  file { '/var/monophylizer/script/monophylizer.pl':
    ensure  => 'file',
    mode    => '0755',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/usr/lib/cgi-bin/monophylizer.pl':
    ensure  => 'link',
    mode    => '0777',
    target  => '/var/monophylizer/script/monophylizer.pl',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/var/www/monophylizer/monophylizer.html':
    ensure  => 'link',
    mode    => '0644',
    target  => '/var/monophylizer/html/monophylizer.html',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/var/www/monophylizer/sorttable.js':
    ensure  => 'link',
    mode    => '0644',
    target  => '/var/monophylizer/script/sorttable.js',
    require => Vcsrepo['/var/monophylizer'],
  }
}
