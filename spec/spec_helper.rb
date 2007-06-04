begin
    require 'rabal'
rescue LoadError
    $: << File.expand_path(File.join(File.dirname(__FILE__),"..","lib"))
    require 'rabal'
end
include Rabal
