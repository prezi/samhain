default['samhain']['config']['Attributes']['file'].tap do |f|
  f['/etc/mtab'] = true
  f['/etc/ssh_random_seed'] = true
  f['/etc/asound.conf'] = true
  f['/etc/resolv.conf'] = true
  f['/etc/localtime'] = true
  f['/etc/ioctl.save'] = true
  f['/etc/passwd.backup'] = true
  f['/etc/shadow.backup'] = true
  f['/etc/postfix/prng_exch'] = true
  f['/etc/adjtime'] = true
  f['/etc/network/run/ifsta'] = true
  f['/etc/lvm/.cache'] = true
  f['/etc/ld.so.cache'] = true
  f['/etc'] = true
end
default['samhain']['config']['LogFiles']['file'].tap do |f|
  f['/var/run/utmp'] = true
  f['/etc/motd'] = true
end
default['samhain']['config']['GrowingLogFiles']['file'].tap do |f|
  f['/var/log/warn'] = true
  f['/var/log/messages'] = true
  f['/var/log/wtmp'] = true
  f['/var/log/faillog'] = true
  f['/var/log/auth.log'] = true
  f['/var/log/daemon.log'] = true
  f['/var/log/user.log'] = true
  f['/var/log/kern.log'] = true
  f['/var/log/syslog'] = true
end
default['samhain']['config']['IgnoreAll']['file'].tap do |f|
  f['/etc/resolv.conf.pcmcia.save'] = true
  f['/etc/nologin'] = true
  f['/etc/network/run'] = true
end
default['samhain']['config']['ReadOnly']['dir'].tap do |d|
  d['/usr/bin'] = true
  d['/bin'] = true
  d['/boot'] = true
  d['3/sbin'] = true
  d['/usr/sbin'] = true
  d['/lib'] = true
  d['3/etc'] = true
end
default['samhain']['config']['ReadOnly']['file'].tap do |f|  
  f['/usr/lib/pt_chown'] = true
end
default['samhain']['config']['EventSeverity']['SeverityReadOnly'] = 'crit'
default['samhain']['config']['EventSeverity']['SeverityLogFiles'] = 'crit'
default['samhain']['config']['EventSeverity']['SeverityGrowingLogs'] = 'warn'
default['samhain']['config']['EventSeverity']['SeverityIgnoreNone'] = 'crit'
default['samhain']['config']['EventSeverity']['SeverityAttributes'] = 'crit'
default['samhain']['config']['EventSeverity']['SeverityIgnoreAll'] = 'info'
default['samhain']['config']['EventSeverity']['SeverityFiles'] = 'crit'
default['samhain']['config']['EventSeverity']['SeverityDirs'] = 'crit'
default['samhain']['config']['EventSeverity']['SeverityNames'] = 'warn'
default['samhain']['config']['Log']['MailSeverity'] = 'crit'
default['samhain']['config']['Log']['PrintSeverity'] = 'none'
default['samhain']['config']['Log']['LogSeverity'] = 'info'
default['samhain']['config']['Log']['SyslogSeverity'] = 'alert'
default['samhain']['config']['Log']['ExportSeverity'] = 'none'
default['samhain']['config']['Misc']['Daemon'] = 'yes'
default['samhain']['config']['Misc']['ChecksumTest'] = 'check'
default['samhain']['config']['Misc']['SetLoopTime'] = '600'
default['samhain']['config']['Misc']['SetFileCheckTime'] = '7200'
default['samhain']['config']['Misc']['SetMailTime'] = '86400'
default['samhain']['config']['Misc']['SetMailNum'] = '10'
default['samhain']['config']['Misc']['SetMailAddress'] = 'root@localhost'
default['samhain']['config']['Misc']['SetMailRelay'] = 'localhost'
default['samhain']['config']['Misc']['MailSubject'] = '[Samhain at %H] %T: %S'
default['samhain']['config']['Misc']['SyslogFacility'] = 'LOG_LOCAL2'
