require 'spec_helper'

RSpec.describe Perambulator::Config do
  it 'creates an app config' do
    config = Perambulator::Config.build do
      file File.expand_path(Pathname.new(__dir__).join('..', 'support', 'files', 'config_test.yml'))
    end
    expect(config.test_encrypted).to eq 'SuperSekret'
    expect(config.test_remote).to eq 'SuperSekret'
    expect(config.test_key).to eq 'foo-bar-baz'
    expect(config.nested.level_one).to eq 'testing-value'
    expect(config.nested.level_two).to eq %w[StringOne StringTwo]
    expect(config.nested.level_three.one).to eq 1
    expect(config.nested.level_three.two).to eq 2
  end
end
