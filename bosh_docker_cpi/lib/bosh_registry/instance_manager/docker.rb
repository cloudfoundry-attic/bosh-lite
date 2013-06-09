module Bosh::Registry

  class InstanceManager

    class Docker < InstanceManager

      require 'bosh_docker_cpi'

      def initialize(cloud_config)
        @docker = ::Docker::API.new(base_url: 'http://localhost:4243')
      end

      # Get the list of IPs belonging to this instance
      def instance_ips(instance_id)
        details = docker.containers.show(instance_id)
        details['NetworkSettings'].map{|network_settings| network_settings['IpAddress']}
      end

      private

      attr_reader :docker
    end
  end
end
