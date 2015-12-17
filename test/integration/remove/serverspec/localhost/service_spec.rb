# Encoding: UTF-8

require_relative '../spec_helper'

describe 'samhain::remove::service' do
  describe service('samhain') do
    it 'is not enabled' do
      expect(subject).to_not be_enabled
    end

    it 'is not running' do
      expect(subject).to_not be_running
    end
  end

  describe file('/etc/init.d/samhain') do
    it 'does not exist' do
      expect(subject).to_not exist
    end
  end
end
