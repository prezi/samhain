# Encoding: UTF-8

require_relative '../spec_helper'

describe 'samhain::default::app' do
  describe package('samhain') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
