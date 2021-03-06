$: << File.expand_path(File.join(File.dirname(__FILE__),"..","lib"))
require 'rabal'

require 'set'
require 'rubygems'
require 'tmpdir'
require 'fileutils'

include Rabal

# generate a temporary directory and create it

def my_temp_dir( unique_id = $$ )
  dirname = File.join( Dir.tmpdir, "sst-agent-#{unique_id}" ) 
  FileUtils.mkdir_p( dirname ) unless File.directory?( dirname )
  return dirname
end

# return a list of all the files and directories in a location
# minus anything leading up to that directory in the path
def find_in(path)
    found = Set.new
    path = path.chomp("/") + "/"
    path = path.reverse.chomp(".").chomp("/").reverse
    Find.find(path) do |f|
        if File.file?(f) or File.directory?(f) then
            f.gsub!(/\A#{path}/,"")
            next if f.size == 0
            found << f 
        end
    end
    found
end

def resource_tree_dir
    File.expand_path(File.join(File.dirname(__FILE__),'..',"resources","trees"))
end

def resource_handle(item)
    File.join(resource_tree_dir,item)
end


#
# Tree used to validate that actions are called
#
class ValidatingActionTree < ActionTree
    @@action_count = 0
    class << self
        def action_count
            @@action_count
        end
    end
    def action
        @@action_count += 1
    end
end

