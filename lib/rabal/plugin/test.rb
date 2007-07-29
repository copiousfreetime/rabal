require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Test < Rabal::Plugin::Base "/rabal/test"
            description "Add a Test::Unit framework."

            def initialize(options)
                @parameters = OpenStruct.new(options)
                validate_parameters
                main_tree_name = my_main_tree_name
                @tree = PluginTree.new({}, resource_by_name(main_tree_name))
            end
        end
    end
end
