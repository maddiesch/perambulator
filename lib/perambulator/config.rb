require 'hashie'
require 'liquid'

require_relative 'configuration'
require_relative 'yaml'
require_relative 'local_cache'

module Perambulator
  class Config
    class << self
      def build(env: nil, cache_path: nil, cache_id: nil, &block)
        instance = new(env)
        instance.build(cache_id, cache_path, &block)
        instance.structure
      end
    end

    attr_reader :structure, :env

    def initialize(env)
      @env = env.peram_presence || Perambulator.config.env
      @structure = Hashie::Mash.new
    end

    def file(file_path)
      @files ||= []
      @files << file_path
    end

    def build(cache_id, local_cache, &block)
      instance_eval(&block)

      return true if load_from_cache(cache_id, local_cache.to_s)

      load_from_files

      save_to_local_cache(cache_id, local_cache.to_s)
    end

    private

    def load_from_files
      Array(@files).each do |path|
        parse(File.read(path))
      end
    end

    def file_integrity
      components = Array(@files).map do |path|
        sha256 = Digest::SHA256.file(path)
        sha256.hexdigest
      end
      Digest::SHA256.hexdigest(components.join('.'))
    end

    def parse(content)
      template = Liquid::Template.parse(content, error_mode: :strict)
      content = template.render!(dynamic_params, strict_variables: true)
      hash = Perambulator::Yaml.parse(content, env)
      add(hash)
    end

    def add(hash)
      mashie = Hashie::Mash.new(hash)
      @structure.deep_merge!(mashie)
      true
    end

    def dynamic_params
      {
        'env' => env
      }
    end

    def cache_file_path(cache_id, base_path)
      Pathname.new(base_path.to_s).join("perambulator_#{env}.#{cache_id.peram_presence || '1'}.dat")
    end

    def save_to_local_cache(cache_id, cache_path)
      return false unless cache_path.peram_present?

      path = cache_file_path(cache_id, cache_path)

      Perambulator::LocalCache.generate(file_integrity, @structure, path)
    end

    def load_from_cache(cache_id, cache_path)
      return false unless cache_path.peram_present?

      path = cache_file_path(cache_id, cache_path)

      return false unless File.exist?(path)

      cached = Perambulator::LocalCache.load(file_integrity, path)

      return false if cached.nil?

      @structure.deep_merge!(cached)

      true
    end
  end
end
