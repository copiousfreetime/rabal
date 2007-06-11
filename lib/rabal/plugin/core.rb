require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Core < Rabal::Plugin::Base "/rabal/core"
            parameter "author", "Author of the project" 
            parameter "email", "Email address of the author"
            use_always
            description <<-DESC
            The core functionality and baseline information needed by every project.  
            DESC
        end
    end
end
