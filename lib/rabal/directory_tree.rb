require 'rabal/action_tree'

module Rabal
    #
    # A directory that is to be created or traversed.  When this Tree is
    # invoked it is assumed that the current working directory is the
    # parent of the directory this DirectoryTree represents.
    #
    class DirectoryTree < ActionTree

        # the File system directory that is the parent of the directory
        # this DirectoryTree represents.
        attr_accessor :parent_dir

        attr_accessor :dir_name

        def initialize(name)
            super
            @dir_name = name
            @parent_dir = nil
        end

        #
        # Make the directory if it doesn't exist 
        #
        def before_action
            @parent_dir = Dir.pwd
            if not File.directory?(dir_name) then
                info("creating directory #{dir_name}")
                Dir.mkdir(dir_name)
            else
                info("skipping directory #{dir_name} - already exists")
            end
        end

        #
        # change into the directory
        #
        def action
            info("changing directory #{dir_name}")
            Dir.chdir(dir_name)
        end

        #
        # change back to the parent directory
        #
        def after_action
            Rabal::Log.info("change directory up to #{File.basename(parent_dir)}")
            Dir.chdir(parent_dir)
        end
    end
end
