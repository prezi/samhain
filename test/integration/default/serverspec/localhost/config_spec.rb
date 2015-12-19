# Encoding: UTF-8

require_relative '../spec_helper'

describe 'samhain::default::config' do
  describe file('/etc/samhain/samhainrc') do
    it 'looks like a valid Samhain config' do
      expected = <<-EOH.gsub(/^ {8}/, '')
        [Attributes]
        file=/etc/mtab
        file=/etc/ssh_random_seed
        file=/etc/asound.conf
      EOH
      expect(subject.content).to include(expected)
    end
  end
end
