# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_samhain_app_ubuntu_precise
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
require_relative 'provider_samhain_app'
require_relative 'provider_samhain_app_ubuntu'

class Chef
  class Provider
    class SamhainApp < LWRPBase
      class Ubuntu < SamhainApp
        # Customize the main Ubuntu provider to wait on the Lucid package that
        # starts the service but exits before it's finished starting up.
        #
        # @author Jonathan Hartman <jonathan.hartman@socrata.com>
        class Precise < Ubuntu
          if defined?(provides)
            provides :samhain_app, platform: 'ubuntu', platform_version: '12.04'
          end

          private

          #
          # Wait for up to five seconds for the service to finish starting
          # after the package's post-install script tells it to.
          #
          # (see Chef::Provider::SamhainApp::Ubuntu#install!)
          #
          def install!
            super
            ruby_block 'Wait for Samhain service to start' do
              block do
                fail if shell_out('ps h -C samhain').stdout.lines.length == 1
              end
              retries 5
              retry_delay 1
              subscribes :run, 'package[samhain]', :immediately
              action :nothing
            end
          end
        end
      end
    end
  end
end
