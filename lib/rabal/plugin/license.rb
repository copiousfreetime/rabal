require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class License < Rabal::Plugin::Base "/builtin/license"
            parameter "license", "Type of Licese for project."
        end
    end
end
