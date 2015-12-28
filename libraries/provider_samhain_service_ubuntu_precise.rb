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
          # Override the start action to wait for Samhain to finish starting.
          #
          # (see Chef::Provider::SamhainService#action_start
          #
          def action_start
            super
            wait_for_samhain_to_start
          end

          #
          # Override the restart action to wait for Samhain to finish starting.
          #
          # (see Chef::Provider::SamhainService#action_restart
          #
          def action_restart
            super
            wait_for_samhain_to_start
          end

          #
          # Use a ruby_block resource to watch and wait if Samhain is in its
          # intermediate starting state where only one process is running
          # instead of zero or two.
          #
          def wait_for_samhain_to_start
            ruby_block 'Wait for Samhain service to start' do
              block do
                fail if shell_out('ps h -C samhain').stdout.lines.length == 1
              end
              retries 5
              retry_delay 1
              subscribes :run, 'service[samhain]', :immediately
              action :nothing
            end
          end
        end
      end
    end
  end
end
