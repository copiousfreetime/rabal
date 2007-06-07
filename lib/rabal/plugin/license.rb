require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class License < Rabal::Plugin::Base "/builtin/license"
            class << self
                def option_name 
                    "license"
                end
                def extend_options(parser,options)
                    parser.on("--license-type LICENSE", "Type of Licese for project")      { |a| options.license = a }
                end
            end
        end
    end
end
