module SamhainCookbook
  module Helpers    
    def self.build_config(node)  
      samhainrc = ''
      node['samhain']['config'].each do |k, v|
        samhainrc << "[#{k}]\n"
        if v.has_key? 'file'
          v['file'].each{ |file, bool| samhainrc << "file=#{file}\n"}
        elsif v.has_key? 'dir'
          v['dir'].each{ |dir, bool| samhainrc << "dir=#{dir}\n" }
        else
          v.each{ |k, v| samhainrc << "#{k}=#{v}\n" }
        end
      end
      return samhainrc
    end
  end
end
