require 'spec_helper'

RSpec.describe GlobalReachPartners::Request do
  subject { described_class.new(:operation) }

  describe '#authentication' do
    it 'returns configuration hash' do
      keys = subject.send(:authentication).keys
      expect(keys).to match_array(%i[client_login user_name password group_ID])
    end
  end

  describe '#client' do
    it 'returns savon client' do
      expect(subject.client).to be_kind_of(Savon::Client)
    end
  end
end
