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
# Copy meta data to facts directory
mkdir -p /etc/facter/facts.d
cp /meta.js /etc/facter/facts.d/meta.js

#
# Run puppet.
#

puppet apply --pluginsync /etc/puppet/manifests/$role.pp
