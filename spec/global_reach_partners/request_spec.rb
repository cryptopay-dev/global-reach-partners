require 'spec_helper'

RSpec.describe GlobalReachPartners::Request do
  let(:operation) { :operation }
  subject { described_class.new(operation) }

  describe '#authentication' do
    it 'raise error' do
      expect { subject.send(:authentication) }
        .to raise_error(NotImplementedError)
    end
  end

  describe '#client' do
    it 'raise error' do
      expect { subject.send(:client) }
        .to raise_error(NotImplementedError)
    end
  end
end
