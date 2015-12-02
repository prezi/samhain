#
# Cookbook Name:: samhain
# Recipe:: default
#
# installs and configures samhain for host integrity monitoring

package 'samhain'

samhainrc = SamhainCookbook::Helpers.build_config(node)

service 'samhain' do
  reload_command 'samhain reload'
end

file '/etc/samhain/samhainrc' do
  content samhainrc
  owner 'root'
  group 'root'
  mode '644'
  notifies :reload, 'service[samhain]'
end

