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

    it 'has syslog as a trusted user', if: os[:release].to_i > 12 do
      expected = <<-EOH.gsub(/^ {8}/, '').strip
        [Misc]
        Daemon=yes
        ChecksumTest=check
        SetLoopTime=600
        SetFileCheckTime=7200
        SetMailTime=86400
        SetMailNum=10
        SetMailAddress=root@localhost
        SetMailRelay=localhost
        MailSubject=[Samhain at %H] %T: %S
        SyslogFacility=LOG_LOCAL2
        TrustedUser=syslog
      EOH
      expect(subject.content).to include(expected)
    end

    it 'does not have syslog as a trusted user', if: os[:release].to_i <= 12 do
      expected = <<-EOH.gsub(/^ {8}/, '').strip
        [Misc]
        Daemon=yes
        ChecksumTest=check
        SetLoopTime=600
        SetFileCheckTime=7200
        SetMailTime=86400
        SetMailNum=10
        SetMailAddress=root@localhost
        SetMailRelay=localhost
        MailSubject=[Samhain at %H] %T: %S
        SyslogFacility=LOG_LOCAL2
      EOH
      expect(subject.content).to include(expected)
    end
  end
end
