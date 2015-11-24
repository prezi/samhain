default['samhain']['Attributes']['file'].tap do |f|
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
default['samhain']['LogFiles']['file'].tap do |f|
  f["/var/run/utmp"] = true,
  f["/etc/motd"] = true
end
default['samhain']['GrowingLogFiles']['file'].tap do |f|
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
default['samhain']['IgnoreAll']['file'].tap do |f|
  f["/etc/resolv.conf.pcmcia.save"] = true,
  f["/etc/nologin"] = true,
  f["/etc/network/run"] = true
end
default['samhain']['ReadOnly']['dir'].tap do |d|
  d["/usr/bin"] = true,
  d["/bin"] = true,
  d["/boot"] = true,
  d["3/sbin"] = true,
  d["/usr/sbin"] = true,
  d["/lib"] = true,
  d["3/etc"] = true
end
default['samhain']['ReadOnly']['file'].tap do |f|  
  f["/usr/lib/pt_chown"] = true
end
default['samhain']['EventSeverity']['SeverityReadOnly'] = "crit"
default['samhain']['EventSeverity']['SeverityLogFiles'] = "crit"
default['samhain']['EventSeverity']['SeverityGrowingLogs'] = "warn"
default['samhain']['EventSeverity']['SeverityIgnoreNone'] = "crit"
default['samhain']['EventSeverity']['SeverityAttributes'] = "crit"
default['samhain']['EventSeverity']['SeverityIgnoreAll'] = "info"
default['samhain']['EventSeverity']['SeverityFiles'] = "crit"
default['samhain']['EventSeverity']['SeverityDirs'] = "crit"
default['samhain']['EventSeverity']['SeverityNames'] = "warn"
default['samhain']['Log']['MailSeverity'] = "crit"
default['samhain']['Log']['PrintSeverity'] = "none"
default['samhain']['Log']['LogSeverity'] = "info"
default['samhain']['Log']['SyslogSeverity'] = "alert"
default['samhain']['Log']['ExportSeverity'] = "none"
default['samhain']['Misc']['Daemon'] = "yes"
default['samhain']['Misc']['ChecksumTest'] = "check"
default['samhain']['Misc']['SetLoopTime'] = "600"
default['samhain']['Misc']['SetFileCheckTime'] = "7200"
default['samhain']['Misc']['SetMailTime'] = "86400"
default['samhain']['Misc']['SetMailNum'] = "10"
default['samhain']['Misc']['SetMailAddress'] = "root@localhost"
default['samhain']['Misc']['SetMailRelay'] = "localhost"
default['samhain']['Misc']['MailSubject'] = "[Samhain at %H] %T: %S"
default['samhain']['Misc']['SyslogFacility'] = "LOG_LOCAL2"
