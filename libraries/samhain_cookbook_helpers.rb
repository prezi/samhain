# Encoding: UTF-8
#
# Cookbook Name:: samhain
# Library:: samhain_cookbook_helpers
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
  class Helpers
    class << self
      #
      # Construct a valid Samhain config based on a config hash.
      #
      # @param config [Hash] a hash represenation of a samhain config
      #
      # @return [String] Contents for a samhainrc file
      #
      def build_config(config)
        return nil if config.nil? || config.empty?
        config.each_with_object([]) do |(section, vals), lines|
          lines.concat(config_section_for(section, vals))
        end.join("\n")
      end

      #
      # Examine a file/dir on the system and determine all the users that have
      # group-write access to it. Members might be either:
      #
      #  * The system user corresponding to the group
      #  * Any system users that are members of the group
      #
      # @param path [String] a system path
      # @param passwd [Chef::Mash,Hash] an Ohai node['etc']['passwd'] section
      # @param group [Chef::Mash,Hash] an Ohai node['etc']['group'] section
      #
      def users_with_group_write_access_for(path, passwd, group)
        gid = File.stat(path).gid
        users = Array(Array(passwd.find { |_, v| v['gid'] == gid })[0])
        users + group.find { |_, vs| vs['gid'] == gid }[1]['members']
      end

      #
      # Determine if a given file/dir path is group-writable.
      #
      # @param path [String] a system path
      #
      # @return [TrueClass,FalseClass] whether the path is group writable
      #
      def group_writable?(path)
        perm = format('%o', File.stat(path).mode)[-2].to_i
        [2, 3, 6, 7].include?(perm)
      end

      private

      #
      # Build the config lines representing a single section of a Samhain
      # config.
      #
      # @param section [String] the name of the section
      # @param vals [Hash] the config values under that section
      #
      # @return [Array<String>] an array of lines representing that config
      #                         section
      #
      def config_section_for(section, vals)
        vals.each_with_object(["[#{section}]"]) do |(k, v), lines|
          case k
          when 'file'
            v.each { |subk, subv| lines << "file=#{subk}" if subv }
          when 'dir'
            v.each { |subk, subv| lines << "dir=#{subk}" if subv }
          else
            lines << "#{k}=#{v}"
          end
        end
      end
    end
  end
end
