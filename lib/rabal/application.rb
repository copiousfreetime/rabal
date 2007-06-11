require 'main'

module Rabal
    #
    # The Rabal application 
    #
    class Application

        attr_accessor :main
        attr_accessor :plugin_manager
        attr_accessor :plugin_load_option_names
        attr_accessor :plugin_option_names
        attr_accessor :global_option_names
        attr_accessor :app_argv

        def initialize
            @main = nil
            @plugin_manager = GemPlugin::Manager.instance
            @plugin_option_names = []
            @global_option_names = %w[directory use-all logfile verbosity version help]
            @plugin_load_option_names = []
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
                plugin_manager.gems["rabal"] = ROOT_DIR
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
                    p_use_name = "use-#{plugin_load_name}"
                    plugin_load_option_names << p_use_name

                    # local variable to build up info from within eval.
                    pons = []

                    main.class.class_eval { 
                        option(p_use_name) { 
                            description "Use plugin #{plugin.name}" 
                        }

                        # add in the plugin options.  Although these are
                        # present in the global main, they won't
                        # actually get displayed in the --help
                        plugin.parameters.each do |pname,pconf|
                            p_option_name = "#{plugin_load_name}-#{pconf[0]}=[p]"
                            pons << p_option_name
                            option(p_option_name) { description pconf[1] } 
                        end
                    } 
                    plugin_option_names.concat(pons)
                end
            end
        end

        #
        # Use Ara's awesome main gem to deal with command line parsing
        #
        def main
            return @main if @main
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

                option("use-all","a") { description "Use all available plugins." }
                option("logfile=l","l") {
                    description "The location of the logfile"
                    default     STDOUT
                }

                option("verbosity=v","v") {
                    validate    { |p| Logger::SEV_LABEL.include?(p.upcase) }
                    description "One of : #{Logger::SEV_LABEL.join(", ")}"

                }

                option("version","V") { 
                    description "Display the version number"
                }

                def run
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
            begin
                # create a separate usage object for rabal that can hook
                # in and figure out what parameters were given on the
                # command line
                u = Rabal::Usage.new(self)
                main.usage u
                main.run 
            rescue ::Main::Parameter::Error => mpe
                puts "ERROR: #{File.basename($0)}: #{mpe.message}"
                puts "Try `#{File.basename($0)} --help' for more information."
            end
        end

        #
        # Get down and do stuff.  Now that all the options have been
        # parsed, plugins loaded, some activate, etc.  
        #
        def rabalize
            max_name = main.params.collect { |p| p.name.length }.max
            main.params.each do |p|
                puts "#{p.name.rjust(max_name)} : #{p.value} "
            end

            # create the core plugin to start things off
            core_params = params_for_plugin(Rabal::Plugin::Core)
            [:directory, :project].each {|k| core_params[k] = main.params[k]}
            core = Rabal::Plugin::Core.new(core_params)
            using_plugins.each do |p|
                next if p === Rabal::Plugin::Core
                pi = p.new(params_for_plugin(p))
                core.tree << pi.tree
            end
            core.process
        end

        #
        # Find a resource associated with the given gem
        #
        def plugin_resource(gem_name,resource_path)
            plugin_manager.resource(gem_name,resource_path)
        end

        #
        # return an array of all the plugin classes being used
        #
        def using_plugins
            using = []
            plugin_manager.plugins.each do |cat,plugins|
                plugins.each do |key,plugin|
                    if main.parameters['use-all'].given? or plugin.use_always? or 
                        main.parameters["use-#{plugin.use_name}"].given? then
                        using << plugin
                    end
                end
            end
        end

        #
        # return a hash of all the options for a particular plugin with
        # the plugins name removed from the front
        #
        def params_for_plugin(plugin)
            plugin_hash = {}
            main.parameters.select{|p| p.type == :option and p.name =~ %r{^#{plugin.use_name}}}.each do |p|
                plugin_hash[p.name.gsub("#{plugin.use_name}-",'')] = p.value
            end
            plugin_hash
        end
    end
end
