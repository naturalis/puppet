require 'spec_helper'

describe 'redis::service' do
  it { should contain_service('redis-server') }
end
