require 'spec_helper'

RSpec.describe Perambulator::Kv do
  describe '.get' do
    context 'given an encrypted key' do
      let(:path) { '/perambulator/test/encrypted-string' }

      it 'fetches without an error' do
        expect { Perambulator::Kv.get(path) }.to_not raise_error
      end

      it 'fetches the correct value' do
        expect(Perambulator::Kv.get(path).value).to eq 'SuperSekret'
      end
    end

    context 'given an un-encrypted key' do
      let(:path) { '/perambulator/test/string-value' }

      it 'fetches without an error' do
        expect { Perambulator::Kv.get(path) }.to_not raise_error
      end

      it 'fetches the correct value' do
        expect(Perambulator::Kv.get(path).value).to eq 'NotQuiteAsSekret'
      end
    end

    context 'given a string set' do
      let(:path) { '/perambulator/test/strings-value' }

      it 'fetches without an error' do
        expect { Perambulator::Kv.get(path) }.to_not raise_error
      end

      it 'fetches the correct value' do
        expect(Perambulator::Kv.get(path).value).to eq %w[StringOne StringTwo]
      end
    end
  end
end
