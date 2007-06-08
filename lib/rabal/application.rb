require 'main'

module Rabal
    #
    # The Rabal application 
    #
    class Application

        attr_accessor :main
        attr_accessor :plugin_manager

        def initialize
            @main = nil
            @plugin_manager = GemPlugin::Manager.instance
            setup_plugins
        end

        #
        # Load any and all plugins that are available.  This includes
        # built in plugins and those that are accessible via gems.
        #
        def setup_plugins 
            plugin_manager.load "rabal" => GemPlugin::INCLUDE
            
            # make sure that we are listed as a plugin generally this is
            # only going to happen if run from outside a gem.  Basically
            # while Jeremy is testing. 
            if not plugin_manager.loaded?("rabal") then
                plugin_manager.gems["rabal"] == ROOT_DIR
            end

            #plugin_manager.plugins.each_pair do |category,plugins|
            #    puts category
            #    plugins.each do |key,plugin|
            #        puts "\t#{key} : #{plugin}"
            #    end
            #end
        end

        #
        # Use Ara's awesome main gem to deal with command line parsing
        #
        def setup_parsing(argv)
            @main = Main.new(argv) {
                description Rabal::DESCRIPTION
                author      "#{Rabal::AUTHOR} <#{Rabal::AUTHOR_EMAIL}>"
                version     Rabal::VERSION

                # Project, the whole reason rabal exists
                argument("project") {
                    description "The project on which rabal is executing."
                }

                # Global Options   
                option("verbosity=v","v") {
                    validate    { |p| Logger::SEV_LABEL.include?(p.upcase) }
                    description "One of : #{Logger::SEV_LABEL.join(",")}"

                }
                option("logfile=l","l") {
                    description "The location of the logfile"
                    default     STDOUT
                }
                option("directory=d","d") {
                    description "The directory in which to create the project directory."
                    validate    { |d| File.directory?(d) }
                }

                def run
                    Rabal.application.rabalize
                end
            }

            # Each plugin has its own options and section iterate
            # over the available plugins and have them add their
            # options to 'main'
           
            Rabal.application.plugin_manager.plugins.each do |category,plugins|
                plugins.each do |key,plugin|
                    option_name = plugin.name.split("::").last.downcase.dashify
                    main.class.class_eval { option("load-#{option_name}") { description "Load plugin #{plugin.name}" } }
                    plugin.parameters.each do |pname,pconf|
                            main.class.class_eval { option("#{option_name}-#{pconf[0]}=[p]") { description pconf[1]} }
                    end
                end
            end

        end

        #
        # Setup the command line parser and execute it
        # main.  The parser's will call its +run+ method which will
        # call 
        # and away we go.  We set
        #
        def run(argv = ARGV)
            setup_parsing(argv)
            main.run
        end

        #
        # Get down and do stuff.  Now that all the options have been
        # parsed, plugins loaded, some activate, etc.  
        #
        def rabalize
        end
    end
end
