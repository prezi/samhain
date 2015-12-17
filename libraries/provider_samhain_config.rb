# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_samhain_config
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
require_relative 'samhain_cookbook_helpers'

class Chef
  class Provider
    # A Chef provider for generating a samhainrc config file.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class SamhainConfig < LWRPBase
      use_inline_resources

      provides :samhain_config if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Generate a config file based on the input config hash.
      #
      action :create do
        file '/etc/samhain/samhainrc' do
          owner 'root'
          group 'root'
          mode '0644'
          content SamhainCookbook::Helpers.build_config(new_resource.config)
        end
      end

      #
      # Delete the samhainrc config file.
      #
      action :remove do
        file('/etc/samhain/samhainrc') { action :delete }
      end
    end
  end
end
