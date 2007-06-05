require 'rabal/action_tree'
require 'erb'

module Rabal
    #
    # Represents a file to be created.  Generally a FileTree will use a
    # source .erb file and combine it with the Rabal::Specification to
    # create +file_contents+.  The +file_contents+ are what are written
    # out in the action.
    #
    # To provide custom template or some decision making, overwrite the
    # +before_action+ method.  So long as +file_contents+ contains the
    # data to write out to the file by the time +action+ is called all
    # is well.
    #
    class FileTree < ActionTree
        alias :name :data

        # the erb template the file is created from as a String
        attr_accessor :template
        
        # the contents of the file to write
        attr_accessor :file_contents

        class << self

            #
            # Create a new FileTree from the path to a file.  The 'name'
            # of the FileTree is basename of the path, minus any
            # extension(.erb by default) .  The contents of the file at
            # path will be loaded into the +template+ member variable.
            #
            def from_file(path,strip_ext = ".erb") 
                template = IO.read(path) 
                name     = File.basename(path,strip_ext)
                FileTree.new(name,template)
            end

        end

        #
        # Create a FileTree with a name from a template
        #
        def initialize(name,template)
            super(name)
            @template = template
            @file_contents = nil
        end

        #
        # before the file is to be created, load the appropriate
        # template and setup any variables that need to be in the
        # binding for erb if there is one
        #
        def before_action
            info("creating content for #{name}")
            @file_contents = ERB.new(template).result(binding)
        end

        #
        # Open up the file and write the contents.  It is assumed that
        # the present working directory is the location for the file to
        # be created.
        #
        def action
            if not File.file?(name) then
                info("writing file #{name}")
                File.open(name,"w+") do |f|
                    f.write(file_contents)
                end
            else
                info("skipping file #{name} - already exists")
            end
        end
    end
end
