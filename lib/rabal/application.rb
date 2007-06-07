require 'ostruct'
require 'optparse'

module Rabal
    #
    # The Rabal application 
    #
    class Application

        attr_accessor :options
        attr_accessor :option_parser

        attr_accessor :stdin
        attr_accessor :stdout
        attr_accessor :stderr
        attr_accessor :log

        attr_accessor :plugin_manager

        def initialize(argv)
            setup_plugins
            begin
                option_parser.parse!(argv)
                options.keys.each do |k1|
                    print "#{k1.to_s.ljust(40)} : "
                    if options[k1].kind_of?(Hash) then
                        puts 
                        options[k1].keys.each do |k2|
                            k = "    #{k2.to_s}".ljust(40)
                            puts "#{k} : #{options[k1][k2].to_s}"
                        end
                    else
                        puts options[k1]
                    end
                end
            rescue OptionParser::ParseError => pe
                puts "ERROR: #{pe}"
                puts option_parser
                exit 1
            end
        end

        #
        # Load any and all plugins that are available.  This includes
        # built in plugins and those that are accessible via gems.
        #
        def setup_plugins 
            @plugin_manager = GemPlugin::Manager.instance
            plugin_manager.load "rabal" => GemPlugin::INCLUDE
            
            # make sure that we are listed as a plugin generally this is
            # only going to happen if run from outside a gem.  Basically
            # while Jeremy is testing. 
            if not plugin_manager.loaded?("rabal") then
                plugin_manager.gems["rabal"] == ROOT_DIR
            end

            # iterate over the available plugins and have them add their
            # options to the option parser.
            plugin_manager.plugins.each_pair do |category,list|
                list.each_pair do |k,plugin|
                    options.by_plugin[plugin] = OpenStruct.new
                    option_parser.on("--with-#{plugin.option_name.dashify}=[PARAMS]","Load plugin #{plugin.name}") do |opts|
                        plugin.extend_options(option_parser,options.by_plugin[plugin])
                    end
                end
            end
        end

        def options 
            if @options.nil? then
                @options = OpenStruct.new
                @options.directory = Dir.pwd
                @options.log_level = Logger::INFO
                @options.log_file  = STDOUT
                @options.by_plugin = {}
            end
            return @options
        end

        def option_parser
            if @option_parser.nil? then
                @option_parser = OptionParser.new do |op|
                    op.on("-d", "--directory DIR", "parent directory of the project tree", 
                            "\tDefault: #{options.directory}")  { |dir| options.directory = dir }

                    op.on("-o", "--log LOG", "logfile location","\tDefault: standard out") { |logfile| options.log_file = logfile }
                    op.on("-v", "--verbosity-level LEVEL", "One of : debug,info,warn,error,fatal",
                            "\tDefault: #{Logger::SEV_LABEL[options.log_level]}") do |level| 
                                if l = Logger::SEV_LABEL.index(level.upcase) then
                                    options.log_level = l
                                else
                                    raise OptionParser::ParseError, "Invalid log level of #{level}"
                                end
                    end
                end
            end
            return @option_parser
        end

        def run
        end
    end
end
