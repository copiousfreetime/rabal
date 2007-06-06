require 'rabal/action_tree'

module Rabal
    include Util
    #
    # A directory that is to be created or traversed.  When this Tree is
    # invoked it is assumed that the current working directory is the
    # parent of the directory this DirectoryTree represents.
    #
    class DirectoryTree < ActionTree
        
        # basename of the directory this Tree represents
        attr_accessor :dir_name

        # the File system directory that is the parent of the directory
        # this DirectoryTree represents.
        attr_accessor :parent_dir


        # Create a DirectoryTree based up a name, or another directory.
        # Only the last portion of the directory is used.  That is
        # +File.basename+ is called upon name.
        def initialize(name)
            super(name)
            @dir_name = File.basename(name)
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
            info("entering directory #{dir_name}")
            Dir.chdir(dir_name)
        end

        #
        # change back to the parent directory
        #
        def after_action
            info("leaving directory #{dir_name}")
            Dir.chdir(parent_dir)
        end
    end
end
