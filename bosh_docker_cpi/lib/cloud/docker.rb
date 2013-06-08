require_relative 'docker/cloud'

module Bosh
  module Clouds
    Docker = Bosh::DockerCloud::Cloud
  end
end
