require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Website < Rabal::Plugin::Base "/rabal/website"
            description "Add a website for your application."
            def initialize(options)
                @parameters = OpenStruct.new(options)
                validate_parameters
                @tree = PluginTree.new({}, resource_by_name(my_main_tree_name))
            end
        end
    end
end
