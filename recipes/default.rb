# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Recipe:: default
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

package 'samhain'

file '/etc/samhain/samhainrc' do
  content SamhainCookbook::Helpers.build_config(node)
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[samhain]'
end

cookbook_file '/etc/init.d/samhain' do
  source 'samhain.startLinux'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'service[samhain]'
end

service 'samhain' do
  supports status: true, restart: true, reload: true
  reload_command 'samhain reload'
  action [:enable, :start]
end
