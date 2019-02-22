require 'spec_helper'

BASE_PATH = Pathname.new(__dir__).join('..', 'support')

RSpec.describe Perambulator::LocalCache do
  let(:integrity) { 'abc123' }

  describe '.load' do
    let(:path) { BASE_PATH.join('files', 'peram_cache.dat') }

    it 'loads the cache' do
      expect { Perambulator::LocalCache.load(integrity, path) }.to_not raise_error
    end

    it 'does not return nil' do
      expect(Perambulator::LocalCache.load(integrity, path)).to_not be_nil
    end
  end

  describe '.generate' do
    let(:path) { BASE_PATH.join('tmp', 'peram_cache.dat') }

    let(:config) do
      Perambulator::Config.build(env: 'production') do
        file File.expand_path(BASE_PATH.join('files', 'config_test.yml'))
      end
    end

    it 'generates a valid cache' do
      expect { Perambulator::LocalCache.generate(integrity, config, path) }.to_not raise_error
    end
  end
end
