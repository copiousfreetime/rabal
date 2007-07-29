require 'rabal/logger'

module Rabal
    #
    # The Rabal application 
    #
    class Application

        include Log

        attr_accessor :main
        attr_accessor :plugin_manager
        attr_accessor :plugin_load_option_names
        attr_accessor :plugin_option_names
        attr_accessor :global_option_names
        attr_accessor :app_argv

        # used for testing mainly
        attr_reader     :stdin
        attr_reader     :stdout
        attr_reader     :stderr


        def initialize(stdin = $stdin, stdout = $stdout, stderr = $stderr)
            @stdin = stdin
            @stdout = stdout
            @stderr = stderr

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
                            p_option_name = "#{plugin_load_name}-#{pconf[:name]}=[p]"
                            pons << p_option_name
                            option(p_option_name) { description pconf[:desc] } 
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
                description Rabal::SPEC.description
                author      Rabal::SPEC.author
                version     Rabal::VERSION

                # Project, the whole reason rabal exists
                argument("project") {
                    description "The project on which rabal is executing."
                }

                # Global Options   
                option("directory=d","d") {
                    description "The directory in which to create the project directory."
                    validate    { |d| File.directory?(d) }
                    default     Dir.pwd
                }

                option("use-all","a") { description "Use all available plugins." }
                option("logfile=l","l") {
                    description "The location of the logfile"
                    default     STDOUT
                }

                option("verbosity=v","v") {
                    validate    { |p| ::Logger::SEV_LABEL.include?(p.upcase) }
                    description "One of : #{::Logger::SEV_LABEL.join(", ")}"
                    default     "INFO"

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
                stderr.puts "Parameter Error: #{File.basename($0)}: #{mpe.message}"
                stderr.puts "Try `#{File.basename($0)} --help' for more information."
                exit 1
            end
        end

        #
        # Get down and do stuff.  Now that all the options have been
        # parsed, plugins loaded, some activate, etc.  
        #
        def rabalize
            logfile_and_level_if_necessary

            # save our current directory for returning
            pwd = Dir.pwd
            begin
                Log.debug("Loading plugins")

                # create the core plugin to start things off
                core_params             = params_for_plugin(Rabal::Plugin::Core)
                core_params[:project]   = main.params[:project].value
                core                    = Rabal::Plugin::Core.new(core_params)

                using_plugins.each do |p|
                    next if p == Rabal::Plugin::Core
                    Log.debug("processing #{p.name} plugin")
                    pi = p.new(params_for_plugin(p))
                    Log.debug("getting tree #{pi.tree.inspect}")
                    core.tree << pi.tree
                end

                # not using chdir blocks, as that raises
                # warning: conflicting chdir during another chdir block
                # hence our saving of pwd before begin
                Dir.chdir(File.expand_path(main.params[:directory].value))

                core.tree.process
            rescue ::Rabal::StandardError => rse
                stderr.puts "Application Error: #{rse.message}"
                exit 1
            rescue Interrupt => ie
                stderr.puts
                stderr.puts "Interrupted"
                exit 1
            ensure
                Dir.chdir(pwd)
            end
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
            using
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

        #
        # if the params for the logfile were given then open them up and
        # 
        def logfile_and_level_if_necessary
            if main.params["logfile"].given? then
                Log.logger = main.params["logfile"].value
            end
            Log.logger.level = ::Logger::SEV_LABEL.index(main.params["verbosity"].value)
            Log.info "Logger initialized"
        end
    end
end
