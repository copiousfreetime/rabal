require 'rabal/action_tree'

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
    class FileTree < Tree
        alias :name :data

        # the contents of the file to write
        attr_accessor :file_contents

        #
        # before the file is to be created, load the appropriate
        # template and setup any variables that need to be in the
        # binding for erb if there is one
        #
        def before_action
        end


        #
        # Open up the file and write the contents.  It is assumed that
        # the present working directory is the location for the file to
        # be created.
        #
        def action
            if not File.is_file?(name) then
                info("#{depth_pad} writing file #{name}")
                File.open(name,"w+") do |f|
                    f.write(file_contents)
                end
            else
                info("skipping file #{name} - already exists")
            end
            File.open(name,"w+") do |f|
                f.puts "Created on #{Time.now}"
            end
        end
    end
end
