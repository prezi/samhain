# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_mapping
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

require 'chef/version'
require 'chef/platform/provider_mapping'
require_relative 'provider_samhain'
require_relative 'provider_samhain_app_ubuntu'
require_relative 'provider_samhain_config'
require_relative 'provider_samhain_service'

if Gem::Version.new(Chef::VERSION) < Gem::Version.new('12')
  Chef::Platform.set(resource: :samhain,
                     provider: Chef::Provider::Samhain)
  Chef::Platform.set(resource: :samhain_app,
                     platform: :ubuntu,
                     provider: Chef::Provider::SamhainApp::Ubuntu)
  Chef::Platform.set(resource: :samhain_config,
                     provider: Chef::Provider::SamhainConfig)
  Chef::Platform.set(resource: :samhain_service,
                     provider: Chef::Provider::SamhainService)
end
