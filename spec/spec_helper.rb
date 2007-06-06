begin
    require 'rabal'
rescue LoadError
    $: << File.expand_path(File.join(File.dirname(__FILE__),"..","lib"))
    require 'rabal'
end
require 'rubygems'
require 'tmpdir'
require 'mktemp'
require 'fileutils'

include Rabal

# generate a temporary directory and create it

def my_temp_dir
    MkTemp.mktempdir(File.join(Dir.tmpdir,"rabal-spec.XXXXXXXX"))
end

# return a list of all the files and directories in a location
# minus anything leading up to that directory in the path
def find_in(path)
    found = []
    path = path.chomp("/") + "/"
    path = path.reverse.chomp(".").chomp("/").reverse
    Find.find(path) do |f|
        if File.file?(f) or File.directory?(f) then
            f.gsub!(/\A#{path}/,"")
            next if f.size == 0
            found << f 
        end
    end
    found.sort
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

