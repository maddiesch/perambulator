module Perambulator
  module Yaml
    class BaseType < String
      attr_reader :original_value

      def self.resolve(value)
        value
      end

      def init_with(coder)
        raw_value = coder.scalar
        resolved = self.class.resolve(raw_value)
        initialize(raw_value, resolved)
      end

      def to_json(_options)
        "\"#{self}\""
      end

      def encode_with(coder)
        coder.scalar = original_value
      end

      private

      def initialize(raw_value, resolved)
        @original_value = raw_value
        super(resolved || '')
      end
    end
  end
end
