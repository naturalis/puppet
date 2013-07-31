Puppet::Parser::Functions::newfunction(:singleton_packages, :doc => <<-'ENDHEREDOC') do |args|
    Create or include a package resource defined either with defaults or with
    hiera-supplied parameters.

    Example usage:

    singleton_packages("vim", "emacs", "nano")

    By default, packages will be created with the parameters:

    package { "singleton_package $arg[n]":
      ensure => present,
      name   => $arg[n],
    }

    Additional customization can be supplied by adding hiera data. You may
    supply parameters, additional singleton_packages to chain-include, and
    additional classes to include. For example (in yaml):

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

  ENDHEREDOC

  Puppet::Parser::Functions.autoloader.loadall

  args.each do |title|
    next if findresource("Package[singleton_package_#{title}]")

    defaults = {
      :parameters => {
        :ensure => :present,
        :name   => title,
      }
    }

    singleton_loaded = self.catalog.classes.include?('singleton')
    function_include(['singleton']) unless singleton_loaded
    scope = self.class_scope('singleton')

    config = scope.function_hiera(["singleton_package_#{title}", defaults])
    config[:parameters]                 ||= {}
    config[:include_singleton_packages] ||= []
    config[:include_classes]            ||= []
    config = Puppet::Util.symbolizehash(config)

    params = defaults[:parameters].merge(config[:parameters])
    resource = { "singleton_package_#{title}" => params }
    scope.function_create_resources(['package', resource])

    scope.function_singleton_packages([config[:include_singleton_packages]])
    scope.function_include([config[:include_classes]])

  end
end
