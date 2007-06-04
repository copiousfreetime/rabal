require 'find'

module Rabal
    # 
    # represents the root of a project directory structure
    #
    class ProjectTree < DirectoryTree
        def initialize(name)
            super
            populate_tree(File.join(APP_DATA_DIR,"trees","rabal","base"))
        end

        private

        def populate_tree(src_directory,root=self)
            Dir.chdir(src_directory) do |pwd|
                Find.find(pwd) do |f|
                    next if f == pwd
                    if File.file?(f) then
                        self << FileTree.new(f)
                    elsif File.directory?(f)
                        self << dir = DirectoryTree.new(f)
                        Find.prune
                        populate_tree(f,dir)
                    end
                end
            end
        end
    end
end
