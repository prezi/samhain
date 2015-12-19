# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Attributes:: default
#
# Copyright 2015 Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['samhain']['app']['source'] = nil
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
default['samhain']['config']['EventSeverity'].tap do |e|
  e['SeverityReadOnly'] = 'crit'
  e['SeverityLogFiles'] = 'crit'
  e['SeverityGrowingLogs'] = 'warn'
  e['SeverityIgnoreNone'] = 'crit'
  e['SeverityAttributes'] = 'crit'
  e['SeverityIgnoreAll'] = 'info'
  e['SeverityFiles'] = 'crit'
  e['SeverityDirs'] = 'crit'
  e['SeverityNames'] = 'warn'
end
default['samhain']['config']['Log'].tap do |l|
  l['MailSeverity'] = 'crit'
  l['PrintSeverity'] = 'none'
  l['LogSeverity'] = 'info'
  l['SyslogSeverity'] = 'alert'
  l['ExportSeverity'] = 'none'
end
default['samhain']['config']['Misc'].tap do |m|
  m['Daemon'] = 'yes'
  m['ChecksumTest'] = 'check'
  m['SetLoopTime'] = '600'
  m['SetFileCheckTime'] = '7200'
  m['SetMailTime'] = '86400'
  m['SetMailNum'] = '10'
  m['SetMailAddress'] = 'root@localhost'
  m['SetMailRelay'] = 'localhost'
  m['MailSubject'] = '[Samhain at %H] %T: %S'
  m['SyslogFacility'] = 'LOG_LOCAL2'
end
