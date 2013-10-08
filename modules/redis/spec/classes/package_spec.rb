require 'spec_helper'

describe 'redis::package' do
  it { should contain_package('redis-server') }
end
