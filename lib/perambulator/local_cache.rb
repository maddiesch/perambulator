require 'fileutils'

module Perambulator
  class LocalCache
    CURRENT_CACHE_VERSION = 2

    class << self
      def load(integrity, path)
        content = File.read(path)
        decoded = Base64.decode64(content)
        cache = Marshal.load(decoded)

        if CURRENT_CACHE_VERSION != cache.version
          cleanup_cache_file(path)
        elsif integrity != cache.integrity
          cleanup_cache_file(path)
        else
          cache.content
        end
      rescue StandardError => error
        STDERR.puts "LocalCache Error: #{error.class.name}: #{error.message}"
        cleanup_cache_file(path)
      end

      def generate(integrity, params, path)
        cache = new(integrity, params)
        content = Marshal.dump(cache)
        encoded = Base64.encode64(content)
        base_path = File.dirname(path)

        FileUtils.mkdir_p(base_path) unless File.directory?(base_path)

        File.open(path, 'w') { |f| f.write(encoded) }
      end

      private

      def cleanup_cache_file(path)
        File.delete(path) if File.exist?(path)

        nil
      end
    end

    attr_reader :content, :integrity, :version

    def initialize(integrity, content)
      @version = Perambulator::LocalCache::CURRENT_CACHE_VERSION
      @generated_at = Time.now
      @integrity = integrity
      @content = content
    end
  end
end
