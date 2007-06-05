begin
    require 'rabal'
rescue LoadError
    $: << File.expand_path(File.join(File.dirname(__FILE__),"..","lib"))
    require 'rabal'
end
require 'rubygems'
require 'mktemp'
require 'fileutils'

include Rabal

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

