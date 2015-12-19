# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_samhain_app
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
require_relative 'provider_samhain_app_ubuntu'

class Chef
  class Provider
    # A Chef provider for the OS-independent pieces of Samhain packages.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class SamhainApp < LWRPBase
      use_inline_resources

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Install the Samhain app.
      #
      action :install do
        install!
      end

      #
      # Uninstall the Samhain app.
      #
      action :remove do
        remove!
      end

      private

      #
      # Install the samhain package.
      #
      def install!
        package(new_resource.source || 'samhain')
      end

      #
      # Remove the samhain package.
      #
      def remove!
        package('samhain') { action :remove }
      end
    end
  end
end
