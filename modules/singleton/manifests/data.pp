class singleton::data {

  # Default parameters for Package resources (singleton)
  $singleton_resource_package = {
    parameters => {
      ensure => present,
    },
  }

  # # Example hiera data for singleton_resource Package["vim"]
  #
  # $singleton_resource_package_vim = {
  #   parameters => {
  #     ensure => present,
  #   },
  #   include_singleton_resources => [
  #     'Package[vim-puppet]',
  #   ],
  # }

  # # Example hiera data for singleton_package "vim"
  #
  # $singleton_package_vim = {
  #   parameters => {
  #     ensure => present,
  #     name   => 'vim',
  #   },
  #   include_singleton_packages => [
  #     "vim-puppet",
  #   ],
  #   include_classes => [
  #     "stdlib",
  #     "obviouslyfakeclass",
  #   ],
  # }

}
