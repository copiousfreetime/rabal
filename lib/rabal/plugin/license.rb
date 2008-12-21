require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        #
        # The license plugin helps the user pick a license for their
        # project.  The current available license to choose from are
        # BSD, GPL, LGPG, MIT and Ruby
        #
        class License < Rabal::Plugin::Base "/rabal/license"
            TYPES = %w[BSD GPL LGPL MIT RUBY ISC]
            parameter "flavor", "Flavor of License for your project: #{TYPES.join(', ')}", lambda { |x| TYPES.include?(x.upcase) }
            description "Indicate under what license your project is released."
            use_always

            def initialize(options)
                @parameters = OpenStruct.new(options)
                validate_parameters
                suffix = @parameters.flavor

                # look at all files in our resource directory and any
                # that have the same suffix as the 'flavor' load it into
                # the tree.
                resource_dir = resource_by_name(my_main_tree_name)
                @tree = DirectoryTree.new(".")
                Dir.glob(File.join(resource_dir,"*.#{suffix.downcase}")).each do |file|
                    @tree << FileTree.from_file(file)
                end
            end
        end
    end
end
