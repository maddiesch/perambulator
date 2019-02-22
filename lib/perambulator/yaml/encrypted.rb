require 'psych'

require_relative 'base_type'
require_relative '../encryption'

module Perambulator
  module Yaml
    class Encrypted < BaseType
      def self.resolve(payload)
        Perambulator::Encryption.decrypt(payload)
      end
    end

    class SafeEncrypted < BaseType
      def self.resolve(payload)
        Perambulator::Encryption.try_decrypt(payload)
      end
    end

    Psych.add_tag('!Encrypted', Perambulator::Yaml::Encrypted)
    Psych.add_tag('!TryEncrypted', Perambulator::Yaml::SafeEncrypted)
  end
end
