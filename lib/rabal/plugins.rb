require 'rubygems'
require 'gem_plugin'

Dir.entries(File.join(File.dirname(__FILE__),'plugins')).each do |rb|
    if rb =~ /\.rb\Z/ then
        f = File.basename(rb,".rb")
        require "rabal/plugins/#{f}"
    end
end
