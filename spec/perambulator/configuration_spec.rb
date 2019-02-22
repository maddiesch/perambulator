require 'spec_helper'

RSpec.describe Perambulator::Configuration do
  it 'can only modify in the configure block' do
    expect { Perambulator.config.aws.region = 'us-east-2' }.to raise_error(RuntimeError) do |error|
      expect(error.message).to eq "can't modify frozen Perambulator::Configuration::AwsConfig"
    end
  end

  it 'can modify in the configure block' do
    Perambulator.configure do |cfg|
      expect { cfg.aws.region = 'us-east-1' }.to_not raise_error
    end
  end
end
