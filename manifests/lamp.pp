class { 'motd': }
class { 'apache': }
class { 'apache::mod::php': }

apache::vhost { 'www.example.com':
        priority        => '10',
        vhost_name      => '192.0.2.1',
        port            => '8000',
        docroot         => '/home/www.example.com/docroot/',
        logroot         => '/srv/www.example.com/logroot/',
        serveradmin     => 'webmaster@example.com',
        serveraliases   => ['example.com',],
    }
