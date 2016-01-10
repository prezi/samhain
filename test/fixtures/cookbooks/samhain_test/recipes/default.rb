# Encoding: UTF-8
#
# Ensure rsyslog is installed on test instances. Newer Ubuntu Docker containers
# come without it, so without the syslog user's group ownership of /var/log.
#

ohai 'users' do
  plugin 'etc'
  action :nothing
end

package 'rsyslog' do
  notifies :reload, 'ohai[users]', :immediately
end

include_recipe 'samhain'
