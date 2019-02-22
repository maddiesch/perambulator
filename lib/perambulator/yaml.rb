require 'psych'

require_relative 'yaml/encrypted'
require_relative 'yaml/key'
require_relative 'yaml/remote'

module Perambulator
  module Yaml
    def self.parse(payload, env)
      Thread.current[:perambulator_parser] = { env: env }
      klasses = [
        Perambulator::Yaml::Encrypted,
        Perambulator::Yaml::SafeEncrypted,
        Perambulator::Yaml::Remote,
        Perambulator::Yaml::Key
      ]
      Psych.safe_load(payload, klasses)
    ensure
      Thread.current[:perambulator_parser] = nil
    end

    def self.current_parser
      Thread.current[:perambulator_parser]
    end
  end
end
