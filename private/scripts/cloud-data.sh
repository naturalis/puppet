#!/bin/sh
set -e -x

role=$1
puppet_source=https://code.google.com/p/demo-puppet-repo/

#
# Default role to init
#
if [ -z $role ]; then role=init; fi

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
# Run puppet.
#

puppet apply /etc/puppet/manifests/$role.pp
