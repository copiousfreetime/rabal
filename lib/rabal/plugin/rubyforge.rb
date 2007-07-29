require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Rubyforge < Rabal::Plugin::Base "/rabal/rubyforge"
            description "Add rubyforge support"
            parameter   "project", "The Rubyforge project/umbrella under which this project resides."

            def initialize(options)
                begin
                    require 'rubyforge'
                rescue LoadError
                    Log::fatal("Unable to use the rubyforge plugin, the rubyforge library is required.")
                    exit 1
                end

                @parameters = OpenStruct.new(options)
                validate_parameters
                @tree = PluginTree.new(@parameters.marshal_dump, resource_by_name(my_main_tree_name))
            end
        end
    end
end
