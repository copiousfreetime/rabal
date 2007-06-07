module Rabal
    #
    # The Rabal application 
    #
    class Application

        include Log

        attr_accessor :options

        attr_accessor :stdin
        attr_accessor :stdout
        attr_accessor :stderr
        attr_accessor :log

        attr_accessor :plugin_manager

        def initialize(argv)
            manage_plugins
            option_parser.parse!
        end

        #
        # Load any and all plugins that are available.  This includes
        # built in plugins and those that are accessible via gems.
        #
        def manage_plugins
            info("Loading plugins")
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
                debug("loaded : #{category} - #{m}")
            end
        end

        def default_options
            @options = OpenStruct.new
            @options.directory = Dir.pwd
            @options.log_level = Logger::INFO
            @options.log_file  = STDOUT
        end

        def option_parser
            OptionParser.new do |op|

                op.on("-d", "--directory DIR", "parent directory of the project tree", 
                        "Default: #{options.directory}")  { |dir| options.directory = dir }

                op.on("-o", "--log LOG", "logfile location","Default: standard out") { |logfile| options.log_file = logfile }
                op.on("-v", "--verbosity-level LEVEL", "One of : debug,info,warn,error,fatal",
                        "Default: #{LLogger::SEV_LABEL[options.log_level]}") do |level| 
                            if l = LLogger::SEV_LABEL.index(level.upcase) then
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
