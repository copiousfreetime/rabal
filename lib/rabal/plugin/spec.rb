require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Spec < Rabal::Plugin::Base "/rabal/spec"
            description "Add an RSpec framework."

            def initialize(options)
                @parameters = OpenStruct.new(options)
                validate_parameters
                main_tree_name = my_main_tree_name
                @tree = PluginTree.new({}, resource_by_name(main_tree_name))
            end
        end
    end
end
