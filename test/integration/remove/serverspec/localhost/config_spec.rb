# Encoding: UTF-8

require_relative '../spec_helper'

describe 'samhain::remove::config' do
  describe file('/etc/samhain/samhainrc') do
    it 'does not exist' do
      expect(subject).to_not exist
    end
  end
end
