#
# Cookbook Name:: samhain
# Recipe:: default
#
# installs and configures samhain for host integrity monitoring

package 'samhain'

service 'samhain' do
  reload_command 'samhain reload'
end

template '/etc/samhain/samhainrc' do
  source 'samhainrc.erb'
  owner 'root'
  group 'root'
  mode '644'
  notifies :reload, 'service[samhain]'
end

node['samhain'].each{ |x| puts x }
