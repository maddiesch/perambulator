require 'aws-sdk-ssm'

require_relative 'parameter'
require_relative 'logger'

module Perambulator
  class Kv
    class << self
      def get(key, aws_region: nil, aws_credentials: nil)
        fetch([key], aws_region: aws_region, aws_credentials: aws_credentials).dig(key)
      end

      def fetch(keys, aws_region: nil, aws_credentials: nil)
        results = {}
        keys.each_slice(10) do |sub_keys|
          Perambulator::Logger.debug "Fetching Key: #{sub_keys}"
          response = client(aws_region, aws_credentials).get_parameters(params(sub_keys))
          response.parameters.each do |param|
            results[param.name] = create_parameter(param)
          end
        end
        results
      end

      private

      def create_parameter(param)
        value = case param.type
                when 'StringList'
                  param.value.split(',')
                else
                  param.value
                end
        Perambulator::Parameter.new(param.name, value, param.type)
      end

      def params(keys)
        {
          names: keys,
          with_decryption: true
        }
      end

      def client(region, credentials)
        Aws::SSM::Client.new(
          region: region || Perambulator.config.aws.region,
          credentials: credentials || Perambulator.config.aws.credentials
        )
      end
    end
  end
end
