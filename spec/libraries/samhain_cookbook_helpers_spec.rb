# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/samhain_cookbook_helpers'

describe SamhainCookbook::Helpers do
  let(:platform) { nil }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  describe '.build_config' do
    let(:config) { nil }
    let(:res) { described_class.build_config(config) }

    context 'a nil config' do
      let(:config) { nil }

      it 'returns the expected samhainrc contents' do
        expect(res).to eq(nil)
      end
    end

    context 'an empty config' do
      let(:config) { {} }

      it 'returns the expected samhainrc contents' do
        expect(res).to eq(nil)
      end
    end

    context 'a partially populated config' do
      let(:config) { { 'Attributes' => { 'file' => { '/etc/mtab' => true } } } }

      it 'returns the expected samhainrc contents' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          [Attributes]
          file=/etc/mtab
        EOH
        expect(res).to eq(expected)
      end
    end

    context 'a fully populated config' do
      let(:config) do
        {
          'Attributes' => {
            'file' => {
              '/etc/mtab' => true,
              '/etc/ssh_random_seed' => true,
              '/etc/asound.conf' => true,
              '/etc/resolv.conf' => true,
              '/etc/localtime' => true,
              '/etc/ioctl.save' => true,
              '/etc/passwd.backup' => true,
              '/etc/shadow.backup' => true,
              '/etc/postfix/prng_exch' => true,
              '/etc/adjtime' => true,
              '/etc/network/run/ifsta' => true,
              '/etc/lvm/.cache' => true,
              '/etc/ld.so.cache' => true,
              '/etc' => true
            }
          },
          'LogFiles' => {
            'file' => {
              '/var/run/utmp' => true,
              '/etc/motd' => true
            }
          },
          'GrowingLogFiles' => {
            'file' => {
              '/var/log/warn' => true,
              '/var/log/messages' => true,
              '/var/log/wtmp' => true,
              '/var/log/faillog' => true,
              '/var/log/auth.log' => true,
              '/var/log/daemon.log' => true,
              '/var/log/user.log' => true,
              '/var/log/kern.log' => true,
              '/var/log/syslog' => true
            }
          },
          'IgnoreAll' => {
            'file' => {
              '/etc/resolv.conf.pcmcia.save' => true,
              '/etc/nologin' => true,
              '/etc/network/run' => true
            }
          },
          'ReadOnly' => {
            'file' => {
              '/usr/lib/pt_chown' => true
            },
            'dir' => {
              '/usr/bin' => true,
              '/bin' => true,
              '/boot' => true,
              '3/sbin' => true,
              '/usr/sbin' => true,
              '/lib' => true,
              '3/etc' => true
            }
          },
          'EventSeverity' => {
            'SeverityReadOnly' => 'crit',
            'SeverityLogFiles' => 'crit',
            'SeverityGrowingLogs' => 'warn',
            'SeverityIgnoreNone' => 'crit',
            'SeverityAttributes' => 'crit',
            'SeverityIgnoreAll' => 'info',
            'SeverityFiles' => 'crit',
            'SeverityDirs' => 'crit',
            'SeverityNames' => 'warn'
          },
          'Log' => {
            'MailSeverity' => 'crit',
            'PrintSeverity' => 'none',
            'LogSeverity' => 'info',
            'SyslogSeverity' => 'alert',
            'ExportSeverity' => 'none'
          },
          'Misc' => {
            'Daemon' => 'yes',
            'ChecksumTest' => 'check',
            'SetLoopTime' => '600',
            'SetFileCheckTime' => '7200',
            'SetMailTime' => '86400',
            'SetMailNum' => '10',
            'SetMailAddress' => 'root@localhost',
            'SetMailRelay' => 'localhost',
            'MailSubject' => '[Samhain at %H] %T: %S',
            'SyslogFacility' => 'LOG_LOCAL2'
          }
        }
      end

      it 'returns the expected samhainrc contents' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          [Attributes]
          file=/etc/mtab
          file=/etc/ssh_random_seed
          file=/etc/asound.conf
          file=/etc/resolv.conf
          file=/etc/localtime
          file=/etc/ioctl.save
          file=/etc/passwd.backup
          file=/etc/shadow.backup
          file=/etc/postfix/prng_exch
          file=/etc/adjtime
          file=/etc/network/run/ifsta
          file=/etc/lvm/.cache
          file=/etc/ld.so.cache
          file=/etc
          [LogFiles]
          file=/var/run/utmp
          file=/etc/motd
          [GrowingLogFiles]
          file=/var/log/warn
          file=/var/log/messages
          file=/var/log/wtmp
          file=/var/log/faillog
          file=/var/log/auth.log
          file=/var/log/daemon.log
          file=/var/log/user.log
          file=/var/log/kern.log
          file=/var/log/syslog
          [IgnoreAll]
          file=/etc/resolv.conf.pcmcia.save
          file=/etc/nologin
          file=/etc/network/run
          [ReadOnly]
          file=/usr/lib/pt_chown
          dir=/usr/bin
          dir=/bin
          dir=/boot
          dir=3/sbin
          dir=/usr/sbin
          dir=/lib
          dir=3/etc
          [EventSeverity]
          SeverityReadOnly=crit
          SeverityLogFiles=crit
          SeverityGrowingLogs=warn
          SeverityIgnoreNone=crit
          SeverityAttributes=crit
          SeverityIgnoreAll=info
          SeverityFiles=crit
          SeverityDirs=crit
          SeverityNames=warn
          [Log]
          MailSeverity=crit
          PrintSeverity=none
          LogSeverity=info
          SyslogSeverity=alert
          ExportSeverity=none
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
        expect(res).to eq(expected)
      end
    end
  end

  describe '#users_with_group_write_access_for' do
    let(:path) { '/var/test' }
    let(:passwd) { {} }
    let(:group) { {} }
    let(:gid) { 123 }
    let(:res) do
      described_class.users_with_group_write_access_for(path, passwd, group)
    end

    before(:each) do
      allow(File).to receive(:stat).with(path).and_return(double(gid: gid))
    end

    context 'a group with no members' do
      let(:group) do
        {
          'test' => { 'gid' => gid, 'members' => [] },
          'test2' => { 'gid' => 456, 'members' => %w(pants shirts) }
        }
      end

      it 'returns an empty array' do
        expect(res).to eq([])
      end
    end

    context 'a group with some members' do
      let(:group) do
        {
          'test' => { 'gid' => gid, 'members' => %w(pants shirts) },
          'test2' => { 'git' => 456, 'members' => %w(spats neckties) }
        }
      end

      it 'returns the group members' do
        expect(res).to eq(%w(pants shirts))
      end
    end

    context 'the group corresponding to a system user' do
      let(:passwd) do
        {
          'user' => { 'uid' => 888, 'gid' => gid },
          'user2' => { 'uid' => 999, 'gid' => 456 }
        }
      end

      let(:group) do
        {
          'user' => { 'gid' => gid, 'members' => [] },
          'user2' => { 'gid' => 456, 'members' => [] },
          'group' => { 'gid' => 789, 'members' => %w(pants shirts) }
        }
      end

      it 'returns the system user' do
        expect(res).to eq(%w(user))
      end
    end
  end

  describe '#group_writable?' do
    let(:path) { '/var/test' }
    let(:mode) { nil }
    let(:res) { described_class.group_writable?(path) }

    before(:each) do
      allow(File).to receive(:stat).with(path).and_return(double(mode: mode))
    end

    [
      { chmod: '755', mode: 16_877, expected: false },
      { chmod: '777', mode: 16_895, expected: true },
      { chmod: '744', mode: 16_868, expected: false },
      { chmod: '724', mode: 16_852, expected: true },
      { chmod: '000', mode: 16_384, expected: false }
    ].each do |test|
      context "chmod #{test[:chmod]}" do
        let(:mode) { test[:mode] }

        it "returns #{test[:expected]}" do
          expect(res).to eq(test[:expected])
        end
      end
    end
  end
end
