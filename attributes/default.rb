default['Attributes']['file'].tap do |f|
  f["/etc/mtab"] = true,
  f["/etc/ssh_random_seed"] = true,
  f["/etc/asound.conf"] = true,
  f["/etc/resolv.conf"] = true,
  f["/etc/localtime"] = true,
  f["/etc/ioctl.save"] = true,
  f["/etc/passwd.backup"] = true,
  f["/etc/shadow.backup"] = true,
  f["/etc/postfix/prng_exch"] = true,
  f["/etc/adjtime"] = true,
  f["/etc/network/run/ifsta"] = true,
  f["/etc/lvm/.cache"] = true,
  f["/etc/ld.so.cache"] = true,
  f["/etc"] = true
end
default['LogFiles']['file'].tap do |f|
  f["/var/run/utmp"] = true,
  f["/etc/motd"] = true
end
default['GrowingLogFiles']['file'].tap do |f|
  f["/var/log/warn"] = true,
  f["/var/log/messages"] = true,
  f["/var/log/wtmp"] = true,
  f["/var/log/faillog"] = true,
  f["/var/log/auth.log"] = true,
  f["/var/log/daemon.log"] = true,
  f["/var/log/user.log"] = true,
  f["/var/log/kern.log"] = true,
  f["/var/log/syslog"] = true
end
default['IgnoreAll']['file'].tap do |f|
  f["/etc/resolv.conf.pcmcia.save"] = true,
  f["/etc/nologin"] = true,
  f["/etc/network/run"] = true
end
default['ReadOnly']['dir'].tap do |d|
  d["/usr/bin"] = true,
  d["/bin"] = true,
  d["/boot"] = true,
  d["3/sbin"] = true,
  d["/usr/sbin"] = true,
  d["/lib"] = true,
  d["3/etc"] = true
end
default['ReadOnly']['file'].tap do |f|  
  f["/usr/lib/pt_chown"] = true
end
default['EventSeverity']['SeverityReadOnly'] = "crit"
default['EventSeverity']['SeverityLogFiles'] = "crit"
default['EventSeverity']['SeverityGrowingLogs'] = "warn"
default['EventSeverity']['SeverityIgnoreNone'] = "crit"
default['EventSeverity']['SeverityAttributes'] = "crit"
default['EventSeverity']['SeverityIgnoreAll'] = "info"
default['EventSeverity']['SeverityFiles'] = "crit"
default['EventSeverity']['SeverityDirs'] = "crit"
default['EventSeverity']['SeverityNames'] = "warn"
default['Log']['MailSeverity'] = "crit"
default['Log']['PrintSeverity'] = "none"
default['Log']['LogSeverity'] = "info"
default['Log']['SyslogSeverity'] = "alert"
default['Log']['ExportSeverity'] = "none"
default['Misc']['Daemon'] = "yes"
default['Misc']['ChecksumTest'] = "check"
default['Misc']['SetLoopTime'] = "600"
default['Misc']['SetFileCheckTime'] = "7200"
default['Misc']['SetMailTime'] = "86400"
default['Misc']['SetMailNum'] = "10"
default['Misc']['SetMailAddress'] = "root@localhost"
default['Misc']['SetMailRelay'] = "localhost"
default['Misc']['MailSubject'] = "[Samhain at %H] %T: %S"
default['Misc']['SyslogFacility'] = "LOG_LOCAL2"
