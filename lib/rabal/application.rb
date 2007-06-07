require 'ostruct'
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
            setup_default_options
            setup_option_parser

            begin
                option_parser.parse!(argv)
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
            puts "loading plugins"
            @plugin_manager = GemPlugin::Manager.instance
            plugin_manager.load "rabal" => GemPlugin::INCLUDE
            
            # make sure that we are listed as a plugin generally this is
            # only going to happen if run from outside a gem.  Basically
            # while Jeremy is testing. 
            if not plugin_manager.loaded?("rabal") then
                plugin_manager.gems["rabal"] == ROOT_DIR
            end

            # dump the available plugins to the log
            plugin_manager.plugins.each_pair do |category,list|
                m = list.collect { |k, v| "#{k} => #{v.to_s}"}.join(', ');
                puts "loaded : #{category} - #{m}"
            end
        end

        def setup_default_options
            @options = OpenStruct.new
            @options.directory = Dir.pwd
            @options.log_level = Logger::INFO
            @options.log_file  = STDOUT
            return @options
        end

        def setup_option_parser
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

        def run
        end
    end
end
