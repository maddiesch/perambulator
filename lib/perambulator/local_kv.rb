require 'digest'

require_relative 'error'

module Perambulator
  class LocalKv
    class << self
      def load!(env, path, cache_dir)
        key = ::Digest::SHA1.hexdigest(path)
        loaded_stores[key] = load_at_path!(env, key, path, cache_dir)
      end

      def get(key)
        loaded_stores.values.map { |store| store.fetch(key) }.compact.first
      end

      private

      def load_at_path!(env, key, path, cache_dir)
        cache_path = cache_dir || File.dirname(path)
        config = Perambulator::Config.build(env: env, cache_id: key, cache_path: cache_path) do
          file(path)
        end
        Store.new(config)
      end

      def loaded_stores
        @loaded_stores ||= {}
      end

      class Store
        attr_reader :storage

        def initialize(storage)
          @storage = storage
        end

        def fetch(key)
          return storage[key] if storage.key?(key)

          key_path = key.split('/').reject(&:empty?)

          storage.dig(*key_path)
        end
      end
    end
  end
end
