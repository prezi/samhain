# Encoding: UTF-8

require_relative '../spec_helper'

describe 'samhain::default' do
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs the Samhain package' do
    expect(chef_run).to install_package('samhain')
  end

  it 'drops off the samhainrc file' do
    expect(chef_run).to create_file('/etc/samhain/samhainrc').with(
      owner: 'root',
      group: 'root',
      mode: '0644'
    )
    expect(chef_run).to render_file('/etc/samhain/samhainrc').with_content(
      <<-EOH.gsub(/^ {8}/, '')
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
    )
    expect(chef_run.file('/etc/samhain/samhainrc'))
      .to notify('service[samhain]').to(:reload)
  end

  it 'drops off an updated Samhain init script' do
    expect(chef_run).to create_cookbook_file('/etc/init.d/samhain').with(
      source: 'samhain.startLinux',
      owner: 'root',
      group: 'root',
      mode: '0755'
    )
    expect(chef_run.cookbook_file('/etc/init.d/samhain'))
      .to notify('service[samhain]').to(:restart)
  end

  it 'enables the Samhain service' do
    expect(chef_run).to enable_service('samhain')
  end

  it 'starts the Samhain service' do
    expect(chef_run).to start_service('samhain')
  end
end
