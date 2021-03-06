require 'rabal'

module Rabal
    include Util
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

        # the name of the file to create
        attr_accessor :file_name

        # the erb template the file is created from as a String
        attr_accessor :template
        
        # the contents of the file to write
        attr_accessor :file_contents
        
        class << self

            #
            # Create a new FileTree from the path to a file.  The +file_name+
            # by default of the FileTree is basename of the path, minus any
            # extension.  This can be altered with the +strip_extension+
            # and +file_name+ parameters.  Passing +nil+ for the
            # +file_name+ achieves the default behavior.
            #
            # The contents of the file at path will be loaded into the 
            # +template+ member variable.
            #
            def from_file(path,strip_ext = true, non_default_file_name = nil)
                template  = IO.read(File.expand_path(path))
                file_name = non_default_file_name || File.basename(path)
                file_name = File.basename(file_name,(strip_ext ? ".*" : ""))
                if file_name.index("-") then
                    file_name = file_name.underscore
                end
                FileTree.new(file_name,template)
            end

        end

        #
        # Create a FileTree with a name from a template
        #
        def initialize(file_name,template)
            super(file_name)
            @file_name = file_name
            @template = template
            @file_contents = nil
        end

        #
        # before the file is to be created, load the appropriate
        # template and setup any variables that need to be in the
        # binding for erb if there is one
        #
        def before_action
            debug("creating content for #{file_name}")
            begin 
                @file_contents = ERB.new(template).result(binding)
            rescue Exception => e
                error("Error evaluating template #{file_name}")
                e.message.split("\n").each do |m|
                    error(m)
                end
            end
        end

        #
        # Open up the file and write the contents.  It is assumed that
        # the present working directory is the location for the file to
        # be created.
        #
        def action
            if not File.file?(file_name) then
                info("creating #{file_name}")
                File.open(file_name,"w+") do |f|
                    f.write(file_contents)
                end
            else
                debug("skipping #{file_name} - already exists")
            end
        end
    end
end
