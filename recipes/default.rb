# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Recipe:: default
#
# Copyright 2015-2016, Socrata, Inc.
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

samhain 'default' do
  config node['samhain']['config'] unless node['samhain']['config'].nil?
  unless node['samhain']['app']['source'].nil?
    source node['samhain']['app']['source']
  end
end

cookbook_file '/usr/sbin/samhain.check' do
  source "samhain.check"
  owner "root"
  group "root"
  mode 0744
end
