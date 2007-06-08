require 'main'

module Rabal
    #
    # The Rabal application 
    #
    class Application

        attr_accessor :main
        attr_accessor :plugin_manager
        attr_accessor :plugins_main 
        attr_accessor :app_argv

        def initialize
            @main = nil
            @plugin_manager = GemPlugin::Manager.instance
            @plugins_main = {}
            @app_argv = []
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

            # Each plugin has its own options so iterate over the
            # available plugins, and create an instance of Main for each
            # plugin.  The options for the plugin will be merged with
            # the global options, and depending on the --load-<plugin>
            # options indicated, they will alter the --help
           
            plugin_manager.plugins.each do |category,plugins|
                plugins.each do |key,plugin|
                    plugin_load_name = plugin.name.split("::").last.downcase.dashify

                    # add the --load-<plugin> option to the global
                    # options
                    main.class.class_eval { option("load-#{plugin_load_name}") { description "Load plugin #{plugin.name}" } }

                    # create an instance of Main for the plugin and save
                    # it off to the side.
                    # instance of Main
                    plugins_main[plugin_load_name] = Main.new { def run; end }

                    # load up the options for the plugin and save them
                    # in its very own instance of Main.  These will be
                    # merged into the global options as need be.
                    plugin.parameters.each do |pname,pconf|
                        plugins_main[plugin_load_name].class.class_eval { option("#{plugin_load_name}-#{pconf[0]}=[p]") { description pconf[1]} }
                    end
                end
            end
        end

        #
        # Use Ara's awesome main gem to deal with command line parsing
        #
        def main
            @main if @main
            @main = Main.new(app_argv) {
                description Rabal::DESCRIPTION
                author      "#{Rabal::AUTHOR} <#{Rabal::AUTHOR_EMAIL}>"
                version     Rabal::VERSION

                # Project, the whole reason rabal exists
                argument("project") {
                    description "The project on which rabal is executing."
                }

                # Global Options   
                option("directory=d","d") {
                    description "The directory in which to create the project directory."
                    validate    { |d| File.directory?(d) }
                }

                option("load-all","a") { description "Load all available plugins." }
                option("logfile=l","l") {
                    description "The location of the logfile"
                    default     STDOUT
                }

                option("verbosity=v","v") {
                    validate    { |p| Logger::SEV_LABEL.include?(p.upcase) }
                    description "One of : #{Logger::SEV_LABEL.join(",")}"

                }

                def run
                    p params
                    Rabal.application.rabalize
                end
            }
        end

        #
        # Invoke main to do its thing and kick off the application
        # Main keeps a reference to the array that it originally started
        # with when it was created.   So you have to have that first,
        # then fill it up later.
        #
        def run(in_argv = ARGV)
            app_argv.clear
            app_argv.concat in_argv.dup
            main.run
        end

        #
        # Get down and do stuff.  Now that all the options have been
        # parsed, plugins loaded, some activate, etc.  
        #
        def rabalize
            puts "Rabalize!"
            puts main.parameters
        end
    end
end
