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

