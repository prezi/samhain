# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_samhain_service_ubuntu_precise
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

require 'chef/provider/lwrp_base'
require_relative 'provider_samhain_service'

class Chef
  class Provider
    class SamhainService < LWRPBase
      class Ubuntu
        # A customized Samhain service provider for Ubuntu 12.04, where the
        # init script exits before the service is completely started.
        #
        # @author Jonathan Hartman <jonathan.hartman@socrata.com>
        class Precise < SamhainService
          if defined?(provides)
            provides :samhain_service,
                     platform: 'ubuntu',
                     platform_version: '12.04'
          end

          #
          # Override the normal service resource to use a custom status check
          # command. This should circumvent the race conditions that arise
          # from the init script on Precise exiting before its status check
          # considers the service fully "started".
          #
          # (see Chef::Provider::SamhainService#samhain_service)
          #
          def samhain_service(actions)
            service 'samhain' do
              supports restart: true, reload: true, status: false
              action actions
            end
          end
        end
      end
    end
  end
end
