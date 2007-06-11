require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        #
        # The license plugin helps the user pick a license for their
        # project.  The current available license to choose from are
        # BSD, GPL, LGPG, MIT and Ruby
        #
        class License < Rabal::Plugin::Base "/rabal/license"
            TYPES = %w[BSD GPL LGPL MIT Ruby]
            parameter "flavor", "Flavor of Licese for your project: #{TYPES.join(', ')}"
            description "Indicate under what license your project is released."
            use_always

            def initialize(options)
                @parameters = OpenStruct.new(options)
                if not @parameters.respond_to?(:flavor) then
                    raise PluginParameterMissingError, "Missing parameter 'flavor' from license plugin.  See --use-license --help"
                end
                suffix = @parameters.flavor
                # look at all files in our resource directory and any
                # that have the same suffix as the 'flavor' load it into
                # the tree.
                if TYPES.include?(suffix) then
                    resource_dir = resource_by_name(my_main_tree_name)
                    @tree = DirectoryTree.new(".")
                    Dir.glob(File.join(resource_dir,"*.#{suffix.downcase}")).each do |file|
                        @tree << FileTree.from_file(file)
                    end
                else
                    raise PluginParameterMissingError, "Invalid value '#{suffix}' for 'flavor' parameter from license plugin.  Only #{TYPES.join(",")} are currently supported."
                end
            end
        end
    end
end
