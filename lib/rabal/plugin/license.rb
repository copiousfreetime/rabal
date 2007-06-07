require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class License < Rabal::Plugin::Base "/builtin/license"
            class << self
                def option_name 
                    "license"
                end
                def extend_options(parser,options)
                end
            end
        end
    end
end
