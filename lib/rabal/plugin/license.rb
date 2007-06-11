require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class License < Rabal::Plugin::Base "/builtin/license"
            TYPES = %w[BSD GPL LGPL MIT Ruby]
            parameter "type", "Type of Licese for your project: #{TYPES.join(', ')}"
            description "Indicate under what license your project is released."
            use_always
        end
    end
end
