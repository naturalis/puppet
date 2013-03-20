#!/bin/sh
role=init
puppet_source=https://code.google.com/p/demo-puppet-repo/


set -e -x
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
# Run puppet.
#

puppet apply /etc/puppet/manifests/$role.pp
