#!/bin/sh
set -e -x

defaultrole=init
puppet_source=https://code.google.com/p/demo-puppet-repo/


#
# Get latest puppet version
#
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get --yes --quiet update
apt-get --yes -o Dpkg::Options::="--force-confold" --quiet install git puppet-common

#
# Fetch puppet configuration from public git repository.
#

mv /etc/puppet /etc/puppet.orig
git clone $puppet_source /etc/puppet

#
# Copy meta data to hiera backend directory
if [ -f /meta.js  ];
then
   cp /meta.js /etc/puppet/hieradata/cloud-init.json
else
   echo "Meta data does not exist."
fi

#
# Get role from hiera
#
role="`hiera -c /etc/puppet/hiera.yaml role $defaultrole 2>&1`"
echo "Role is: $role"

#
# Run puppet.
#

puppet apply /etc/puppet/manifests/$role.pp
