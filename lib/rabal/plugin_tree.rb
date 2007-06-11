require 'rabal'
require 'find'

module Rabal
    # 
    # Represents the root of a plugin directory structure.  This plugin
    # could also only represent a single FileTree by having the
    # 'directory' it represents being '.'
    #
    class PluginTree < DirectoryTree

        # the source directory from which the project is generated 
        attr_accessor :src_directory

        # create a new Plugin Tree based upon a source directory.  This
        # 'mounts' the src_directory into the dest_directory in the
        # project.  The dest_directory defaults to "."
        def initialize(src_directory,dest_directory= ".")
            super(dest_directory)
            @src_directory = src_directory
        end

        #
        # populating the tree needs to take place after the PluginTree
        # has been added to the Tree, but before the processing of the
        # tree takes place
        # 
        def post_add
            populate_tree(src_directory)
        end

        private

        # 
        # Given a source directory populate a PluginTree based upon the
        # contents of the directory.  All files will be mapped to
        # FileTree and directories will be mapped to DirectoryTree.
        #
        def populate_tree(src_directory,tree=self)
            Dir.chdir(src_directory) do |pwd|
                Dir.entries(".").each do |entry|
                    next if entry[0] == ?.
                    next if pwd == entry
        
                    if File.file?(entry) then
                        tree << FileTree.from_file(entry,true,replace_known_words(entry))
                    elsif File.directory?(entry) then
                        tree << dir = DirectoryTree.new(replace_known_words(entry))
                        populate_tree(entry,dir)
                    end
                end
            end
        end
    end
end
