require 'spec_helper'

RSpec.describe Perambulator::Yaml::Encrypted do
  let(:encrypted) do
    'AQICAHjwdQf1BpuL8E9uZtI6Mpx6jfIuNUHultdQftAf0REWRwHq7HPt5IbHm9kSrJhuDB1j' \
    'AAAAaTBnBgkqhkiG9w0BBwagWjBYAgEAMFMGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM' \
    '2ALnPtxsR-6sKmzEAgEQgCaZUF95UKC885X1F6QPmtVzm13XMisX_ZDiHQZ1BUZICL3BSzDa' \
    '8w=='
  end

  describe '!Encrypted' do
    subject { Perambulator::Yaml.parse("test: !Encrypted #{encrypted}", 'test') }

    it 'decryptes without an error' do
      expect { subject }.to_not raise_error
    end

    it 'decryptes with the expected value' do
      expect(subject).to eq('test' => 'SuperSekret')
    end
  end
end
