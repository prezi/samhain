#
# Cookbook Name:: samhain
# Recipe:: default
#
# installs and configures samhain for host integrity monitoring

package 'samhain'

def build_config
  samhainrc = ''
  node['samhain'].each do |k, v|
    samhainrc << "[#{k}]\n"
    if v.has_key? 'file'
      v['file'].each{ |file, bool| samhainrc << "file=#{file}\n"}
    elsif v.has_key? 'dir'
      v['dir'].each{ |dir, bool| samhainrc << "dir=#{dir}\n" }
    else
      v.each{ |k, v| samhainrc << "#{k}=#{v}\n" }
    end
  end
  return samhainrc
end

samhainrc = build_config

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

