# Singleton Puppet Module

The Singleton module provides functions that dynamically create resources
defined either by built-in defaults or by hiera-supplied parameters.


## Dependencies

### create_resources

This module requires Puppet >= 2.7.14 due to the following bug in the create_resources function

* [http://projects.puppetlabs.com/issues/13567](http://projects.puppetlabs.com/issues/13567)

### Hiera

This module depends on hiera which is introduced in Puppet 3.0. Users on lower versions can use the 
following rubygems which provides this functionality:

    gem install hiera hiera-puppet

* [http://github.com/puppetlabs/hiera](http://github.com/puppetlabs/hiera)
* [http://github.com/puppetlabs/hiera-puppet](http://github.com/puppetlabs/hiera-puppet)

## Functions

### singleton_packages

singleton_packages is intended to be used as a tool to address the problem of
simple package inclusion in puppet manifests.

Because resources can only be declared once in a puppet manifest, including
"simple" packages in multiple places can become a complicated and verbose
endeavour -- where "simple packages" are loosely defined as those which are too
inconsequential to merit their own classes or modules. The `singleton_packages`
function aims to detach inclusion of these kinds of trivial packages from the
complexity of the Puppet DAG and eliminate the need to a-priori enumerate the
entire list of trivial packages that you might want to include (via means such
as classes, virtual resources, or other contrivances), while simultaneously
allowing for a small level of user-excersised power and control beyond global
or function-wide default parameters.

The `singleton_package` function is called with the name(s) of the package(s)
to install. It does not matter how many times the function is called for a
given package name, the resource will only be defined once, and will be defined
within the scope of Class[singleton].

### singleton_resources

singleton_resources is a generalization from singleton_packages to arbitrary
resource types. While singleton_packages expects string arguments,
singleton_resources expects resource specifiers such as Package['vim'].

# Examples

## singleton_packages

The following puppet code can be used to install three packages, "vim",
"emacs", and "nano".

    singleton_packages("vim", "emacs", "nano")

By default, each package will be created as if it had been given the parameters:

    package { "singleton_package_$name":
      ensure => present,
      name   => $name,
    }

Additional customization can be supplied by adding hiera data. You may supply
parameters, additional singleton_packages to chain-include, and additional
classes to include.

### YAML Example for "vim" Package

File: $confdir/data/common.yaml
(or other appropriate file, per hiera configuration)

    ---
    :singleton_package_vim:
      :parameters:
        :name: vim
        :ensure: present
      :include_singleton_packages:
      - vim-puppet
      :include_classes:
      - stdlib
      - obviouslyfakeclass

### Puppet Example for "vim" Package

File: $modulepath/data/manifests/common.pp
(or other appropriate file/class, per hiera configuration)

    class data::common {
      $singleton_package_vim = {
        parameters => {
          ensure => present,
          name   => 'vim',
        },
        include_singleton_packages => [
          "vim-puppet",
        ],
        include_classes => [
          "stdlib",
          "obviouslyfakeclass",
        ],
      }
    }

## singleton_resources

The following puppet code can be used to install three packages, "vim",
"emacs", and "nano".

    singleton_resources(
      Package['vim'],
      Package['emacs'],
      Package['nano'],
    )

Default parameters must be supplied for every type used with
singleton_resources. The singleton module comes with a set of defaults only for
the Package resource type. Other defaults must be supplied by the user.

For the Package['vim'] example and the module-supplied package resource
defaults, Package['vim'] will be created as if it had been given the
parameters:

    package { "$title":
      ensure => present,
      name   => $title,
    }

### Defaults for Package resource type (YAML)

    ---
    :singleton_resource_package:
      :parameters:
        :ensure: present

### Package['vim'] Customization (YAML)

    ---
    :singleton_resource_package_vim:
      :parameters:
        :name: vim
        :ensure: present
      :include_singleton_resources:
      - Package[vim-puppet]
      :include_classes:
      - stdlib
      - obviouslyfakeclass

### Package['vim'] Customization (Puppet)

    class data::common {
      $singleton_resource_package_vim = {
        parameters => {
          ensure => present,
          name   => 'vim',
        },
        include_singleton_resources => [
          "Package[vim-puppet]",
        ],
        include_classes => [
          "stdlib",
          "obviouslyfakeclass",
        ],
      }
    }
