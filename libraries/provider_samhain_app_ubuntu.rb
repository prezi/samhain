# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_samhain_app_ubuntu
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

require 'chef/dsl/include_recipe'
require 'chef/provider/lwrp_base'
require_relative 'provider_samhain_app'

class Chef
  class Provider
    class SamhainApp < LWRPBase
      # A Chef provider for the Samhain app package for Ubuntu.
      #
      # @author Jonathan Hartman <jonathan.hartman@socrata.com>
      class Ubuntu < SamhainApp
        include Chef::DSL::IncludeRecipe

        provides :samhain_app, platform: 'ubuntu' if defined?(provides)

        private

        #
        # Ensure the APT cache is up to date and install the Samhain package.
        #
        # (see Chef::Provider::SamhainApp#install!)
        #
        def install!
          include_recipe 'apt'
          super
        end

        #
        # Use the :purge action to remove Samhain instead of :remove.
        #
        # (see Chef::Provider::SamhainApp#remove!)
        #
        def remove!
          package('samhain') { action :purge }
        end
      end
    end
  end
end
