require 'rabal/action_tree'

module Rabal
    #
    # Represents a file
    #
    class FileTree < Tree
        alias :name :data
        def action
            File.open(name,"w+") do |f|
                f.puts "Created on #{Time.now}"
            end
        end
    end
end
