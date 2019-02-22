require 'aws-sdk-core'

module Perambulator
  def self.configure(&block)
    Perambulator::Configuration.configure(&block)
  end

  def self.config
    Perambulator::Configuration.config
  end

  class Configuration
    CONFIG_LOCK = Mutex.new

    FROZEN_DUPED_ATTRS = %i[
      aws
      kms
      local_environments
    ].freeze

    AwsConfig = Struct.new(:region, :credentials)

    KmsConfig = Struct.new(:key_arn)

    class << self
      def configure
        CONFIG_LOCK.synchronize do
          config = _config.dup
          yield(config)
          _config(config)
        end
      end

      def config
        return _config if CONFIG_LOCK.owned?

        CONFIG_LOCK.synchronize { _config }
      end

      private

      def _config(config = nil)
        unless config.nil?
          @_config = config
          @_config.send(:_finalize)
          @_config = @_config.freeze
        end
        @_config ||= Perambulator::Configuration.new.freeze
        @_config
      end
    end

    attr_reader :aws
    attr_reader :kms
    attr_reader :local_environments

    attr_accessor :env
    attr_accessor :verbose

    def initialize
      @aws = AwsConfig.new('us-east-1', nil)
      @kms = KmsConfig.new(nil)
      @local_environments = %w[development test]
      @operation_queue = []
      @verbose = false
      if defined?(::Rails)
        @env = ::Rails.env
        @verbose = ::Rails.env.development? || ::Rails.env.test?
        load_local_kv(
          ::Rails.root.join('config', 'perambulator', 'local_key_value.yml'),
          ::Rails.root.join('tmp', 'perambulator')
        )
      end
    end

    def load_local_kv(path, cache_dir = nil)
      @operation_queue << [:_load_local_kv, [path, cache_dir]]
    end

    def freeze
      FROZEN_DUPED_ATTRS.each do |name|
        instance_variable_get("@#{name}").freeze
      end
      super
    end

    def dup
      instance = super
      FROZEN_DUPED_ATTRS.each do |name|
        value = instance_variable_get("@#{name}").dup
        instance.instance_variable_set("@#{name}", value)
      end
      instance
    end

    def local?(env)
      local_environments.include?(env)
    end

    private

    def _finalize
      while (cmd = @operation_queue.shift)
        send(cmd.first, *cmd.last)
      end
    end

    def _load_local_kv(path, cache_dir)
      Perambulator::LocalKv.load!(env, path.to_s, cache_dir.to_s.peram_presence)
    end
  end
end
