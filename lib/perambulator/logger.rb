require_relative 'configuration'

module Perambulator
  class Logger
    class << self
      def debug(message)
        return unless Perambulator.config.verbose

        STDOUT.puts "PERAM: #{message}"
      end
    end
  end
end
