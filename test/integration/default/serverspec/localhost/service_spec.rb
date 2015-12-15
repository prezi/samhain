# Encoding: UTF-8

require_relative '../spec_helper'

describe 'samhain::default::service' do
  describe service('samhain') do
    it 'is enabled' do
      expect(subject).to be_enabled
    end

    it 'is running' do
      expect(subject).to be_running
    end
  end

  describe command('service samhain reload') do
    it 'exit successfully' do
      expect(subject.exit_status).to eq(0)
    end
  end
end
