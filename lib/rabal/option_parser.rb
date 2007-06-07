require 'rabal'
require 'optparse'

module Rabal
    #
    # OptionParser wraps ::OptionParser and give is a more pleasing
    # appearance for use with Plugins.  
    #
    # The only methods that are available for this facade on
    # ::OptionParser are +on+ +on_tail+ and +on_head+
    #
    class OptionParser 
        # 
        # Fake appearances like ::OptionParser
        #
        def initialize(banner = nil, width = 32, indent = ' ' * 4)
            @option_parser = ::OptionParser.new(banner,width,indent)
            yield self if block_given?
        end

        private
        def option_parser
            @option_parser
        end
    end
end


