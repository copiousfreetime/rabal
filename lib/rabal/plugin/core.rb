require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Core < Rabal::Plugin::Base "/rabal/core"
            parameter "author", "Author of the project" 
            parameter "email", "Email address of the author"
            use_always
            description <<-DESC
            The core functionality and baseline information needed by every project.  
            DESC

            # core is slightly different from the default and uses a
            # ProjecTree instead of a PluginTree.  It does attach a
            # PluginTree below the project tree with the basic file
            # structure
            def initialize(options)
                @parameters = OpenStruct.new(options)
                validate_parameters
                @tree = ProjectTree.new(options[:project] || options["project"],options)
                @tree << PluginTree.new({},resource_by_name(my_main_tree_name))
            end
        end
    end
end
