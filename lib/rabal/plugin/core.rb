require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Core < Rabal::Plugin::Base "/builtin/core"
            parameter "author", "Author of the project" 
            parameter "email", "Email address of the author"
        end
    end
end
