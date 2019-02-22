require 'spec_helper'

RSpec.describe Perambulator::Presence do
  describe '#peram_present?' do
    it { expect('foo').to be_peram_present }

    it { expect(nil).to_not be_peram_present }

    it { expect('').to_not be_peram_present }
  end

  describe '#peram_presence' do
    it { expect('foo'.peram_presence).to eq 'foo' }

    it { expect(nil.peram_presence).to be_nil }

    it { expect(''.peram_presence).to be_nil }
  end
end
