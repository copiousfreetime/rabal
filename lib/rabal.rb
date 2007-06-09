module Rabal
    AUTHOR          = "Jeremy Hinegardner".freeze
    AUTHOR_EMAIL    = "jeremy@hinegadner.org".freeze
    HOMEPAGE        = "http://copiousfreetime.rubyforge.org/rabal/"
    COPYRIGHT       = "2007 #{AUTHOR}".freeze
    DESCRIPTION     = <<DESC
Rabal is a commandline application for bootstrapping, packaging and
distributing ruby projects.
DESC

    ROOT_DIR        = File.expand_path(File.join(File.dirname(__FILE__),".."))
    LIB_DIR         = File.join(ROOT_DIR,"lib").freeze
    RESOURCE_DIR    = File.join(ROOT_DIR,"resources").freeze
    TEMPLATE_DIRS   = [ File.join(RESOURCE_DIR,"trees").freeze ]
    KNOWN_WORDS     = {
        "rabal.project" => lambda { |tree| tree.root.name }
    }

    #
    # Utility method to require all files ending in .rb that lie in the
    # directory below this file that has the same name as the filename
    # passed in.
    #
    def require_all_libs_relative_to(fname)
        search_me = File.join(File.dirname(fname),File.basename(fname,".*"))
        
        Dir.entries(search_me).each do |rb|
            if File.extname(rb) == ".rb" then
                require File.join(search_me,rb)
            end
        end
    end 
    module_function :require_all_libs_relative_to

    #
    # Module singleton methods, allow for accessing a single rabal
    # application from anywhere
    #
    class << self
        def application
            @application ||= Rabal::Application.new
        end

        def application=(app)
            @application = app
        end
    end
end
Rabal.require_all_libs_relative_to(__FILE__)
