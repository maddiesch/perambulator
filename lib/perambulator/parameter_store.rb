require_relative 'configuration'
require_relative 'error'
require_relative 'kv'

module Perambulator
  class ParameterStore
    class << self
      def get(path, env: nil)
        env = env.peram_presence || Perambulator.config.env

        raise Perambulator::Error, 'Missing an environment' unless env.peram_present?

        if Perambulator.config.local?(env)
          Perambulator::LocalKv.get(path)
        else
          Perambulator::Kv.get(path)&.value
        end
      end
    end
  end
end
