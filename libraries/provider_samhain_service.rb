# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: provider_samhain_service
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
require_relative 'resource_samhain_service'

class Chef
  class Provider
    # A Chef provider for the Samhain service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class SamhainService < LWRPBase
      use_inline_resources

      provides :samhain_service if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Iterate over each service action and pass it on to a normal service
      # resource. This has to be done with a temporary service resource because
      # the `allowed_actions` class method didn't exist yet in the version of
      # Chef 11 we need to maintain support for.
      #
      Resource::SamhainService.new('_', nil).allowed_actions.each do |a|
        action(a) do
          samhain_service(a)
        end
      end

      #
      # Normally, the service definition comes with the app package, so the
      # :create action doesn't need to do anything.
      #
      action(:create) {}

      #
      # Ensure that the Samhain service definition is deleted.
      #
      action :remove do
        file('/etc/init.d/samhain') { action :delete }
      end

      private

      #
      # Split the samhain service resource out to its own method so other child
      # classes can easily override it as needed.
      #
      # @param actions [Symbol, Array<Symbol>] action(s) to perform on the
      #                                        Samhain service resource
      def samhain_service(actions)
        service 'samhain' do
          supports restart: true, reload: true, status: true
          action actions
        end
      end
    end
  end
end
