#!/bin/sh
set -e -x

defaultrole=init
puppet_source=https://github.com/naturalis/puppet.git


#
# Get latest puppet version
# Debian like
if [ -f /usr/bin/dpkg ]
then
 # wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
 # dpkg -i puppetlabs-release-precise.deb
  wget http://apt.puppetlabs.com/puppetlabs-release-stable.deb
  dpkg -i puppetlabs-release-stable.deb
  apt-get --yes --quiet update
  apt-get --yes -o Dpkg::Options::="--force-confold" --quiet install git puppet-common
fi

# centos
if [ -f /bin/rpm ]
then
  rpm -Uhv http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
  curl -O http://apt.sw.be/redhat/el6/en/x86_64/extras/RPMS/git-1.7.10-1.el6.rfx.x86_64.rpm
  curl -O http://apt.sw.be/redhat/el6/en/x86_64/extras/RPMS/perl-Git-1.7.10-1.el6.rfx.x86_64.rpm
  yum -y install perl-DBI rsync
  rpm -i git-1.7.10-1.el6.rfx.x86_64.rpm perl-Git-1.7.10-1.el6.rfx.x86_64.rpm
  yum -y install puppet
fi

#
# Fetch puppet configuration from public git repository.
#

mv /etc/puppet /etc/puppet.orig
env GIT_SSL_NO_VERIFY=true git clone --recursive $puppet_source /etc/puppet

#
# Copy meta data to hiera backend directory
if [ -f /meta.js  ];
then
   cp /meta.js /etc/puppet/hieradata/cloud-init.json
else
   echo "Meta data does not exist."
fi

#
# get role from hiera
#
role="`hiera -c /etc/puppet/hiera.yaml role $defaultrole 2>&1`"

#
# Run puppet.
#

puppet apply /etc/puppet/manifests/$role.pp
