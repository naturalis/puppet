#!/bin/sh
set -e -x

# Script to:
# -Install puppet and git 
# -Checkout a git repo to the /etc/puppet directory
# -Apply a 'role', a role is translated to a puppet manifest found in /etc/puppet/manifests/$role.pp
#
# The role to be applied can be specified as:
# 1. A parameter on the commandline
# 2. As meta data when starting a cloud instance
# 3. Somewhere in the hiera data
# If there is no role specified, the role 'init' is used.

#
# Tested on:
# Ubuntu 12.04-64 'precise'
# Ubuntu 13.04 'raring'
# CentOs 6.4-64
#
# Usage:
# Download this script from:
# https://raw.github.com/naturalis/puppet/master/private/scripts/cloud-puppet.sh
# Make executable
# chmod +x ./cloud-puppet.sh
#
# Deployment examples:
# 1. Apply the 'puppetdev' manifest on this machine
# ./cloud-puppet.sh puppetdev
#
# 2. Apply the 'puppetci' manifest to a openstack instance
# nova boot --user-data cloud-puppet.sh --meta role=puppetci --image precise-x86_64 --flavor m1.tiny --key-name mykey puppetci
#
# 3. Apply the 'monophylizer' manifest to a openstack instance using hiera data (edit cloud-data to include your own url).
# wget https://github.com/naturalis/puppet/raw/master/private/scripts/cloud-data
# nova boot --user-data cloud-data --meta role=monophylizer --image precise-x86_64 --flavor m1.tiny --key-name mykey monophylizer
#
# 4. Apply the 'monophylizer' manifest to a openstack instance using user provided hiera datafile (user-data.yaml).
# nova boot --user-data cloud-data --meta role=monophylizer --image precise-x86_64 --flavor m1.tiny --key-name mykey --file user-data.yaml=/user-data.yaml monophylizer
#

# Standard role
defaultrole=init

# Git repository to clone
puppet_source=https://github.com/naturalis/puppet.git

#
# Start of code
#

#
# Get latest puppet version
#

# Debian like
if [ -f /usr/bin/dpkg ]
then
  wget http://apt.puppetlabs.com/puppetlabs-release-stable.deb
  dpkg -i puppetlabs-release-stable.deb
  apt-get --yes --quiet update
  apt-get --yes -o Dpkg::Options::="--force-confold" --quiet install git puppet-common ruby1.9.1 libaugeas-ruby
fi

# centos
if [ -f /bin/rpm ]
then
  rpm -Uhv --force http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
  curl -O http://apt.sw.be/redhat/el6/en/x86_64/extras/RPMS/git-1.7.10-1.el6.rfx.x86_64.rpm
  curl -O http://apt.sw.be/redhat/el6/en/x86_64/extras/RPMS/perl-Git-1.7.10-1.el6.rfx.x86_64.rpm
  yum -y install perl-DBI rsync
  rpm -i --force git-1.7.10-1.el6.rfx.x86_64.rpm perl-Git-1.7.10-1.el6.rfx.x86_64.rpm
  yum -y install puppet
fi

#
# Move original puppet directory
#
if [ -d "/etc/puppet.orig" ]; then
  rm -rf /etc/puppet.orig
fi
mv /etc/puppet /etc/puppet.orig

#
# Fetch puppet configuration from public git repository.
#
env GIT_SSL_NO_VERIFY=true git clone --recursive $puppet_source /etc/puppet

#
# Copy meta data to hiera backend directory
#
# cloud-init json file
if [ -f /meta.js  ]; then
   cp /meta.js /etc/puppet/hieradata/cloud-init.json
fi
# user-data yaml file
if [ -f /user-data.yaml  ]; then
   cp /user-data.yaml /etc/puppet/hieradata/user-data.yaml
fi


#
# get role from commandline or if absent from hiera
#
if [ $# -gt 0 ]; then
  role=$1
else
  role="`hiera -c /etc/puppet/hiera.yaml role $defaultrole 2>&1`"
fi
#
# Run puppet.
#
if [ -f /etc/puppet/manifests/$role.pp  ]; then
  puppet apply /etc/puppet/manifests/$role.pp
else
  echo "/etc/puppet/manifests/$role.pp was not found!"
  exit 1
fi
