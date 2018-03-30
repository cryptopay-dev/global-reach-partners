require 'spec_helper'

RSpec.describe GlobalReachPartners::FxPlugin::Request do
  let(:operation) { :operation }
  subject { described_class.new(operation) }

  describe '#authentication' do
    it 'returns configuration hash' do
      keys = subject.send(:authentication).keys
      expect(keys).to match_array(%i[client_code username password group_ID])
    end
  end

  describe '#client' do
    it 'returns savon client' do
      expect(subject.client).to be_kind_of(Savon::Client)
    end
  end

  describe 'invalid credentials' do
    let(:operation) { :get_rate_matrix }

    it 'raises errors', vcr: { cassette_name: 'fx_plugin/invalid_credentials' } do
      expect { subject.call({ error_msg: '' }) }.to raise_error(GlobalReachPartners::Error, 'Credential Failed.')
    end
  end
end
