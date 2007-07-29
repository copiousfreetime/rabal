require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Ext < Rabal::Plugin::Base "/rabal/ext"
            description "Add a ruby extension"
            parameter "soname", "Name of the resulting .so file (e.g.  myext)"
            parameter "lib_name", "Library to link against (e.g. libsomething)"
            parameter "lib_method", "Check for the existence of this method in the library"

            def initialize(options)
                @parameters = OpenStruct.new(options)
                validate_parameters
                @tree = PluginTree.new({}, resource_by_name(main_tree_name))
            end

        end
    end
end
