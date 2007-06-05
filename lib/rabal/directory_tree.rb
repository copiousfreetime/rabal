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

        alias :name :data

        #
        # Make the directory if it doesn't exist 
        #
        def before_action
            Rabal::Log.debug("parent dir = #{Dir.pwd}")
            @parent_dir = Dir.pwd
            if not File.directory?(name) then
                Rabal::Log.info("make directory #{name}")
                Dir.mkdir(name)
            else
                Rabal::Log.info("skip directory #{name} - already exists")
            end
        end

        #
        # change into the directory
        #
        def action
            Rabal::Log.info("change directory #{name}")
            Dir.chdir(name)
        end

        #
        # change back to the parent directory
        #
        def after_action
            Rabal::Log.info("change directory #{parent_dir}")
            Dir.chdir(parent_dir)
        end
    end
end
