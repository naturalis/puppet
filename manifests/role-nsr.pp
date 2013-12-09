# == Class: role-nsr
#
# init.pp for nsr puppet module
#
# Author : Hugo van Duijn
#
class { 'nsr':
    backup              => true,
    restore             => false,
    bucket              => 'linuxbackups',
    bucketfolder        => 'nsr',
    dest_id             => $dest_id,
    dest_key            => $dest_key,
    cloud               => 's3',
    coderepo            => 'svn://dev2.etibioinformatics.nl/linnaeus_ng/trunk',
    repotype            => 'svn',
    userDbName          => 'nsr',
    appVersion          => '1.0.0',
}
