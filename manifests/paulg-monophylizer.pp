  
class { 'monophylizer': }


# Create all virtual hosts from hiera
class monophylizer::instances
{
  create_resources('apache::vhost', hiera('monophylizer', []))
}

class monophylizer
{
  perl::module { 'Bio::Phylo': }
  class { 'perl': }

# Create apache server
  class { 'apache':
    before  => Class['monophylizer'],
  }

  class { 'monophylizer::instances':
    before  => Class['monophylizer'],
  }

  vcsrepo { '/var/monophylizer':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/ncbnaturalis/monophylizer.git',
  }

  file { '/var/monophylizer/script/monophylizer.pl':
    ensure  => 'file',
    mode    => '0755',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/var/www/monophylizer/cgi-bin':
    ensure  => 'directory',
    mode    => '0755',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/usr/lib/cgi-bin/monophylizer.pl':
    ensure  => 'link',
    mode    => '0777',
    target  => '/var/monophylizer/script/monophylizer.pl',
    require => File['/var/www/monophylizer/cgi-bin'],
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
