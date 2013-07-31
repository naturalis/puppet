Puppet::Parser::Functions::newfunction(:singleton_resources, :doc => <<-'ENDHEREDOC') do |args|
    Create or include a resource defined either with defaults or with 
    hiera-supplied parameters.

    Example usage:

    singleton_resources(Package['vim'], Package['emacs'], User['fu'])

    By default, packages will be created with parameters specified in hiera
    keys of the form:

    singleton_resource_${type}_${title}

    Additionally, default values can be specified using the hiera key

    singleton_resource_${type}

    The data should be in the form of a hash, which can include the keys:

    parameters
    include_singleton_resources
    include_classes

    Parameters should be a hash containing the parameters to give to the
    resource.

    include_singleton_resources should be an array of singleton_resources to
    chain-include when the singleton_resource in question is called.

    include_classes should be an array of classes to include when the 
    singleton_resource in question is called.

    For example (in YAML):

    ---
    :singleton_resource_package_vim:
      :parameters:
        :name: vim
        :ensure: present
      :include_singleton_resources:
      - Package['vim-puppet']
      :include_classes:
      - stdlib
      - obviouslyfakeclass

  ENDHEREDOC

  Puppet::Parser::Functions.autoloader.loadall

  blank_config = {
    :parameters => {},
    :include_singleton_resources => [],
    :include_classes => []
  }

  singleton_loaded = self.catalog.classes.include?('singleton')
  function_include(['singleton']) unless singleton_loaded
  scope = self.class_scope('singleton')

  args.flatten.each do |resource|
    case resource
    when String
      # convert into resource
      resource = Puppet::Resource.new(nil, resource)
    when Puppet::Resource
      # yay!
    else
      raise ArgumentError, "Invalid argument of type '#{val.class}' to 'singleton_resources'"
    end

    next if function_defined([resource])

    type  = resource.type.downcase
    title = resource.title.downcase
    defaults_key = "singleton_resource_#{type}"
    resource_key = "singleton_resource_#{type}_#{title}"

    defaults = scope.function_hiera([defaults_key])
    config   = scope.function_hiera([resource_key, defaults])

    config = Puppet::Util.symbolizehash(config)
    config[:parameters] = Puppet::Util.symbolizehash(config[:parameters])
    config = blank_config.merge(config)

    defaults = Puppet::Util.symbolizehash(defaults)
    defaults[:parameters] = Puppet::Util.symbolizehash(defaults[:parameters])
    defaults = blank_config.merge(defaults)

    class_includes = defaults[:include_classes].concat(
      config[:include_classes]
    ).uniq

    singleton_includes = defaults[:include_singleton_resources].concat(
      config[:include_singleton_resources]
    ).uniq

    params = { :name => title }.merge(
      defaults[:parameters].merge(
        config[:parameters]
    ))

    scope.function_create_resources([type, {title => params}])
    scope.function_singleton_resources([singleton_includes])
    scope.function_include([class_includes])

  end

end
