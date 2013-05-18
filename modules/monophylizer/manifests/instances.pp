# Create all virtual hosts from hiera
class monophylizer::instances
{
  create_resources('apache::vhost', hiera('monophylizer', []))
}
