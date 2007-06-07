require 'rabal'
require 'optparse'
require 'stringio'

module Rabal
    #
    # OptionParser wraps ::OptionParser and give is a more pleasing
    # appearance for use with Plugins.  
    #
    # All it really does in intercept the 
    class OptionParser
        # 
        # Fake appearances like ::OptionParser
        #
        def initialize(banner = nil, width = 32, indent = ' ' * 4)
            @option_parser = ::OptionParser.new(banner,width,indent)
            @current_section_key = :global
            @sections = {}
            yield self if block_given?
        end

        def current_section
            @sections[@current_section_key] ||= []
        end

        # delegate options to the actual parser
        def on(*opts,&block)
            if @current_section_key != :global then
                list = make_only_long_switch(opts,block)
            else 
                list = make_switch(opts,block)
            end
            current_section << list
            @option_parser.top.append(*list)
        end

        def program_name
            @option_parser.program_name
        end

        def for_section(section)
            @current_section_key = section
            self
        end

        def to_s
            io = StringIO.new
            io.puts @option_parser.banner
            io.puts
            io.puts "GLOBAL OPTIONS"
            io.puts
            section_to_io(@sections[:global],io)

            @sections.keys.reject{|k| k == :global }.sort_by{|k| k.to_s }.each do |key|
                io.puts
                io.puts "PLUGIN OPTIONS - #{key.to_s}"
                section_to_io(@sections[key],io)
            end

            io.string
            #@option_parser.to_s
        end

        alias :help :to_s

        def section_to_io(section,io)
            section.each do |opt|
                opt.first.summarize({},{},32,30,"    ") do |line|
                    io.puts line
                end
            end
            nil
        end

        def parse!(argv)
            @option_parser.parse!(argv)
        end

        private
        def make_switch(opts,block)
            @option_parser.make_switch(opts,block)
        end
        def make_only_long_switch(opts,block)
            list = make_switch(opts,block)
            list[0].short.clear
            list[1].clear
            list
        end

        def add_option_list_to_section(section,list)
            @sections[section] = list
            @option_parser.top.append(*list)
        end

        def option_parser
            @option_parser
        end
    end
end


