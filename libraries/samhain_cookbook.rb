# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: samhain_cookbook
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

module SamhainCookbook
  # A set of helper methods for generating a valid Samhain config.
  #
  # @author Ele Mooney <ele.mooney@socrata.com>
  module Helpers
    #
    # Construct a valid Samhain config based on a node object.
    #
    # @param node [Chef::Node] a node object with Samhain attributes
    #
    # @return [String] Contents for a samhainrc file
    #
    def self.build_config(node)
      lines = []
      node['samhain']['config'].map do |section, vals|
        lines << "[#{section}]"
        (vals['file'] || {}).each { |k, v| lines << "file=#{k}" if v }
        (vals['dir'] || {}).each { |k, v| lines << "dir=#{k}" if v }
        vals.each do |k, v|
          lines << "#{k}=#{v}" unless %w(file dir).include?(k)
        end
      end
      lines.join("\n")
    end
  end
end
