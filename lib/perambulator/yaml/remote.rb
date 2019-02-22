require 'psych'

require_relative 'base_type'

module Perambulator
  module Yaml
    class Remote < BaseType
      def self.resolve(payload)
        Perambulator::ParameterStore.get(payload, env: 'production')
      end
    end

    Psych.add_tag('!Remote', Perambulator::Yaml::Remote)
  end
end
