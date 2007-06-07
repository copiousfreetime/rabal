#!/urs/bin/env ruby

$: << "./lib"
require 'rubygems'
require 'gem_plugin'

def loaded_plugins
    if  GemPlugin::Manager.instance.plugins.size > 0 then
        GemPlugin::Manager.instance.plugins.each_pair do |category,h|
            puts "Registered as: #{category}"
            h.each_pair do |key,klass|
                puts "\t #{key} => #{klass}"
            end
        end
    else
        puts "No plugins loaded"
    end
end

puts "==========> Before loading Rabal <================"
loaded_plugins

puts
require 'rabal'
puts "==========> require 'rabal' <================"

loaded_plugins


