class { 'apache': }
class { 'apache::mod::php': }
class { 'apache::mod::rewrite': }
# Create all virtual hosts from hiera
create_resources('apache::vhost', hiera('virtualhosts', []))
