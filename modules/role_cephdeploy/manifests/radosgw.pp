class role_cephdeploy::radosgw (
  $ceph_monitor_fsid = 'e80afa94-a64c-486c-9e34-d55e85f26406',
  $ceph_monitor_secret = 'AQAJzNxR+PNRIRAA7yUp9hJJdWZ3PVz242Xjiw==',
  $cinder_rbd_user = 'admin',
  $cinder_rbd_pool = 'volumes',
  $cinder_rbd_secret_uuid = 'e80afa94-a64c-486c-9e34-d55e85f26406',
  $mon_initial_members = 'mon1',
  $primary_mon = 'mon1',
  $ceph_monitor_address = '192.168.20.37,', # yes leave the trailing comma intact for now
  $ceph_deploy_user = 'admin',
  $ceph_deploy_password = 'changeme',
  $ceph_cluster_interface = 'eth0',
  $ceph_public_interface = 'eth0',
  $ceph_public_network = '192.168.20.0/24',
  $ceph_cluster_network = '192.168.20.0/24',
){
#  class { 'cephdeploy':
#    user     => $ceph_deploy_user,
#    pass     => $ceph_deploy_password,
#    require    => Class[ 'cephdeploy::radosgw::ceph' ],
#  }
# include cephdeploy::baseconfig
  class { 'cephdeploy::baseconfig':
    user     => $ceph_deploy_user,
    pass     => $ceph_deploy_password,
    ceph_primary_mon => $primary_mon,
} 
  class { 'cephdeploy::radosgw::apt': }
  class { 'cephdeploy::radosgw::apache': 
    require    => Class[ 'cephdeploy::radosgw::apt' ],
  }
  class { 'cephdeploy::radosgw::ceph':
    cluster    => 'cephcluster',
    cluster_id => 1,
    swiftuser  => 'swift',
    require    => Class[ 'cephdeploy::radosgw::apache' ],
#    require => exec['install ceph'],
#    require    => Class[ 'cephdeploy::radosgw::apache', 'cephdeploy::baseconfig' ],
  }
}

