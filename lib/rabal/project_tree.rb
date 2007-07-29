require 'rabal'

module Rabal
    #
    # The ProjectTree represents the master configuration/specification
    # of a project.
    #
    class ProjectTree < DirectoryTree

        # FIXME: this should derive a whole bunch of instance variables
        # and delegate items to a Gem specification.
        def initialize(project_name,options)
            super(project_name)
            if options.kind_of?(OpenStruct) then
                options = options.marshal_dump
            end
            @parameters = OpenStruct.new(options)
            @parameters.project_name = project_name
        end
    end
end
