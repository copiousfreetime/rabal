require 'rabal/action_tree'

module Rabal
    #
    # A directory in 
    class DirectoryTree < ActionTree
        alias :name :data
        def action
            Dir.mkdir(name)
        end
    end
end
