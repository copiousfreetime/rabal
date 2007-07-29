require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Rubyforge < Rabal::Plugin::Base "/rabal/rubyforge"
            description "Add rubyforge support"
            parameter   "project", "The Rubyforge project/umbrella under which this project resides."

            def initialize(options)
                @parameters = OpenStruct.new(options)
                validate_parameters
                @tree = PluginTree.new({}, resource_by_name(my_main_tree_name))
            end
        end
    end
end
