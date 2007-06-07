module Rabal
    #
    # The ProjectTree represents the master configuration/specification
    # of a project.
    #
    class ProjectTree < DirectoryTree

        attr_accessor :project_name
        attr_accessor :author
        attr_accessor :email

        # FIXME: this should derive a whole bunch of instance variables
        # and delegate items to a Gem specification.
        def initialize(project_name,author,email)
            super(project_name)
            @project_name = project_name
            @author = author
            @email = email
        end

    end
end
