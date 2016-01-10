# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_samhain
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

class Chef
  class Provider
    # A parent Chef provider for all the Samhain components.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class Samhain < LWRPBase
      use_inline_resources

      provides :samhain if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Install, configure, and enable+start Samhain.
      #
      action :create do
        samhain_app(new_resource.name) do
          source new_resource.source unless new_resource.source.nil?
        end
        samhain_config(new_resource.name) do
          config new_resource.config unless new_resource.config.nil?
          notifies :reload, "samhain_service[#{new_resource.name}]"
        end
        samhain_service(new_resource.name)
      end

      #
      # Disable+stop Samhain, remove its configuration, and uninstall the app.
      #
      action :remove do
        samhain_service(new_resource.name) { action [:stop, :disable, :remove] }
        samhain_config(new_resource.name) { action :remove }
        samhain_app(new_resource.name) { action :remove }
      end
    end
  end
end
