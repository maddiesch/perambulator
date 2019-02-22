require 'psych'

require_relative 'base_type'
require_relative '../yaml'

module Perambulator
  module Yaml
    class Key < BaseType
      def self.resolve(payload)
        env = Perambulator::Yaml.current_parser.fetch(:env)

        Perambulator::ParameterStore.get(payload, env: env)
      end
    end

    Psych.add_tag('!Key', Perambulator::Yaml::Key)
  end
end
