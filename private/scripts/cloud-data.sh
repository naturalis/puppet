#!/bin/sh
set -e -x

role=init
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
   cp /meta.js /var/lib/hiera/defaults.json
else
   echo "Meta data does not exist."
fi

#
# Run puppet.
#

puppet apply --pluginsync /etc/puppet/manifests/$role.pp
