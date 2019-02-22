require 'spec_helper'

RSpec.describe Perambulator::Encryption do
  describe '.encrypt' do
    it 'encrypts the data without raising an error' do
      expect { Perambulator::Encryption.encrypt('SuperSekret') }.to_not raise_error
    end
  end

  describe '.decrypt' do
    context 'given a valid payload' do
      let(:payload) do
        'AQICAHjwdQf1BpuL8E9uZtI6Mpx6jfIuNUHultdQftAf0REWRwGjzLLJdb-jj_2QhPeoJB' \
        'XxAAAAaTBnBgkqhkiG9w0BBwagWjBYAgEAMFMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4w' \
        'EQQMtrUavq0qmC4y2A_nAgEQgCYAkWgSBl1frJXpCfj8FdxDJNGnxko-9UEz2A7fg9NHJs' \
        'Izu4PUAg=='
      end

      it 'decrypts the payload without an error' do
        expect { Perambulator::Encryption.decrypt(payload) }.to_not raise_error
      end

      it 'has the expected value' do
        expect(Perambulator::Encryption.decrypt(payload)).to eq 'SuperSekret'
      end
    end

    context 'given invalid base64' do
      let(:payload) do
        'foo-bar-baz'
      end

      it 'raises an error' do
        expect { Perambulator::Encryption.decrypt(payload) }.to raise_error(Perambulator::Encryption::DecryptionError) do |error|
          expect(error.message).to eq 'invalid base64'
        end
      end
    end

    context 'given an invalid payload' do
      let(:payload) do
        'aW52YWxpZC1wYXlsb2Fk'
      end

      it 'raises an error' do
        expect { Perambulator::Encryption.decrypt(payload) }.to raise_error(Perambulator::Encryption::DecryptionError) do |error|
          expect(error.message).to eq 'Aws::KMS::Errors::InvalidCiphertextException'
        end
      end
    end

    context 'given a different key' do
      let(:payload) do
        'AQICAHgQv60A_HRF1DSoxbreCiqbxJf89G1IeTGoac6HrMIG5AGkksIvh8DLYtqPT8jo' \
        'MrLOAAAAaTBnBgkqhkiG9w0BBwagWjBYAgEAMFMGCSqGSIb3DQEHATAeBglghkgBZQME' \
        'AS4wEQQMXWPTsXJ-MNnCPLo7AgEQgCZJIqC3TAadpPYHSgS-GUOrVKBxo1KSPeP1KfzC' \
        'AUbu-5i9vVaodQ=='
      end

      it 'raises an error' do
        expect { Perambulator::Encryption.decrypt(payload) }.to raise_error(Perambulator::Encryption::DecryptionError) do |error|
          expect(error.message).to eq 'The ciphertext refers to a customer master key that does not exist, does not exist in this region, or you are not allowed to access.'
        end
      end
    end

    context 'given a nil payload' do
      it 'has a nil value' do
        expect(Perambulator::Encryption.decrypt(nil)).to be_nil
      end
    end

    context 'given an empty payload' do
      it 'has a nil value' do
        expect(Perambulator::Encryption.decrypt('')).to be_nil
      end
    end
  end

  describe '.try_decrypt' do
    context 'given a valid payload' do
      let(:payload) do
        'AQICAHjwdQf1BpuL8E9uZtI6Mpx6jfIuNUHultdQftAf0REWRwGjzLLJdb-jj_2QhPeoJB' \
        'XxAAAAaTBnBgkqhkiG9w0BBwagWjBYAgEAMFMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4w' \
        'EQQMtrUavq0qmC4y2A_nAgEQgCYAkWgSBl1frJXpCfj8FdxDJNGnxko-9UEz2A7fg9NHJs' \
        'Izu4PUAg=='
      end

      it 'decrypts the payload without an error' do
        expect { Perambulator::Encryption.try_decrypt(payload) }.to_not raise_error
      end

      it 'has the expected value' do
        expect(Perambulator::Encryption.try_decrypt(payload)).to eq 'SuperSekret'
      end
    end

    context 'given invalid base64' do
      let(:payload) do
        'foo-bar-baz'
      end

      it 'decrypts the payload without an error' do
        expect { Perambulator::Encryption.try_decrypt(payload) }.to_not raise_error
      end

      it 'has the expected value' do
        expect(Perambulator::Encryption.try_decrypt(payload)).to eq nil
      end
    end

    context 'given an invalid payload' do
      let(:payload) do
        'aW52YWxpZC1wYXlsb2Fk'
      end

      it 'decrypts the payload without an error' do
        expect { Perambulator::Encryption.try_decrypt(payload) }.to_not raise_error
      end

      it 'has the expected value' do
        expect(Perambulator::Encryption.try_decrypt(payload)).to eq nil
      end
    end

    context 'given a different key' do
      let(:payload) do
        'AQICAHgQv60A_HRF1DSoxbreCiqbxJf89G1IeTGoac6HrMIG5AGkksIvh8DLYtqPT8jo' \
        'MrLOAAAAaTBnBgkqhkiG9w0BBwagWjBYAgEAMFMGCSqGSIb3DQEHATAeBglghkgBZQME' \
        'AS4wEQQMXWPTsXJ-MNnCPLo7AgEQgCZJIqC3TAadpPYHSgS-GUOrVKBxo1KSPeP1KfzC' \
        'AUbu-5i9vVaodQ=='
      end

      it 'decrypts the payload without an error' do
        expect { Perambulator::Encryption.try_decrypt(payload) }.to_not raise_error
      end

      it 'has the expected value' do
        expect(Perambulator::Encryption.try_decrypt(payload)).to eq nil
      end
    end

    context 'given a nil payload' do
      it 'has a nil value' do
        expect(Perambulator::Encryption.try_decrypt(nil)).to be_nil
      end
    end

    context 'given an empty payload' do
      it 'has a nil value' do
        expect(Perambulator::Encryption.try_decrypt('')).to be_nil
      end
    end
  end
end
