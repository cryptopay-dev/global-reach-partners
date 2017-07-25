require 'spec_helper'

RSpec.describe GlobalReachPartners::Request do
  let(:operation) { :operation }
  subject { described_class.new(operation) }

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

  describe '#call' do
    let(:operation) { :get_currencies }
    let(:message) { { error_msg: '' } }

    it 'returns savon client', vcr: { cassette_name: 'operations/get_currencies' } do
      expect(subject.call(message)).to be_kind_of(Savon::Response)
    end
  end
end
