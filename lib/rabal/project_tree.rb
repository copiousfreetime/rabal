require 'rabal'
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

        # 
        # Given a source directory populate a ProjectTree based upon the
        # contents of the directory.  All files will be mapped to
        # FileTree and directories will be mapped to DirectoryTree.
        #
        def populate_tree(src_directory,root=self)
            Dir.chdir(src_directory) do |pwd|
                Find.find(pwd) do |f|
                    next if f == pwd
                    if File.file?(f) then
                        self << FileTree.from_file(f)
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
