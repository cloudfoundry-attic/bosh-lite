require 'spec_helper'

describe Bosh::Clouds::Docker do

  subject(:docker) { described_class.new({}) }

  it 'loads' do
    docker.should_not be_nil
  end

  it 'loads from the provider interface' do
    Bosh::Clouds::Provider.create('docker', {}).should be_a_kind_of(described_class)
  end
end
