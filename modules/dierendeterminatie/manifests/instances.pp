# Create all virtual hosts from hiera
class dierendeterminatie::instances
{
  create_resources('apache::vhost', hiera('dierendeterminatie', []))

}
