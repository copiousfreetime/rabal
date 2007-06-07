require 'rabal/plugin/foundation'
module Rabal
    module Plugin
        class Core < Rabal::Plugin::Base "/builtin/core"
            class << self
                def option_name
                    "core"
                end
                def extend_options(parser,options)
                    parser.on("--core-author AUTHOR", "Author of the project")      { |a| options.author = a }
                    parser.on("--core-email EMAIL", "Email address of the author") { |e| options.email = e }
                end
            end
        end
    end
end
