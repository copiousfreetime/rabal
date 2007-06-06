require 'rabal'
require 'find'

module Rabal
    # 
    # represents the root of a project directory structure
    #
    class ProjectTree < DirectoryTree

        # the source directory from which the project is generated 
        attr_accessor :src_directory

        # create a new Project Tree based upon a source directory
        # template designated by +template_name+.  The known template
        # directories are searched for a matching location and that is
        # used as the +src_directory+.
        def initialize(name,template_name)
            super(name)
            src_directory = Rabal::Application.find_src_directory(template_name)
            populate_tree(src_directory)
        end

        private

        # 
        # Given a source directory populate a ProjectTree based upon the
        # contents of the directory.  All files will be mapped to
        # FileTree and directories will be mapped to DirectoryTree.
        #
        def populate_tree(src_directory,tree=self)
            Dir.chdir(src_directory) do |pwd|
                Dir.entries(".").each do |entry|
                    next if entry[0] == ?.
                    next if pwd == entry
                   
                    if File.file?(entry) then
                        tree << FileTree.from_file(replace_known_words(entry))
                    elsif File.directory?(entry) then
                        tree << dir = DirectoryTree.new(replace_known_words(entry))
                        populate_tree(entry,dir)
                    end
                end
            end
        end
    end
end
