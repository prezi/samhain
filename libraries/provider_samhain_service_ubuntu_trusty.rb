# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_samhain_service_ubuntu_trusty
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

require 'chef/provider/lwrp_base'
require_relative 'provider_samhain_service'

class Chef
  class Provider
    class SamhainService < LWRPBase
      class Ubuntu
        # A customized Samhain service provider for Ubuntu 14.04, where it
        # ships with an init script with broken :reload and :restart actions.
        #
        # @author Jonathan Hartman <jonathan.hartman@socrata.com>
        class Trusty < SamhainService
          if defined?(provides)
            provides :samhain_service,
                     platform: 'ubuntu',
                     platform_version: '14.04'
          end

          #
          # Override the base create action to patch in a fix for reloads and
          # restarts.
          #
          # (see Chef::Provider::SamhainService#action_create)
          #
          action :create do
            file '/etc/init.d/samhain' do
              owner 'root'
              group 'root'
              mode '0755'
              content lazy {
                ::File.open('/etc/init.d/samhain').read.gsub(
                  "pidofproc -p $PIDFILE\n", "pidofproc -p $PIDFILE $DAEMON\n"
                )
              }
            end
          end
        end
      end
    end
  end
end
