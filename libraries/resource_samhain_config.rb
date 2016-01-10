# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: resource_samhain_config
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

require 'chef/resource/lwrp_base'
require_relative 'provider_samhain_config'

class Chef
  class Resource
    # A Chef resource for a Samhain configuration.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class SamhainConfig < LWRPBase
      self.resource_name = :samhain_config
      actions :create, :remove
      default_action :create

      #
      # Attribute for an input config hash.
      #
      attribute :config, kind_of: Hash, default: nil
    end
  end
end
