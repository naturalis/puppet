require 'spec_helper'

describe 'redis::config' do
  it { should contain_file('/etc/redis/redis.conf') }
end
