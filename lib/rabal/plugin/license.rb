require 'rabal'
module Rabal
    module Plugin
        class License < GemPlugin::Plugin "/builtin/license"
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
