require 'logger'
module Rabal
    module Log
        LOGGER                 = Logger.new(STDOUT)
        LOGGER.datetime_format = "%Y-%m-%d %H:%M:%S"


        class << self
            %w(debug info warn error fatal).each do |m|
                module_eval <<-code 
                    def #{ m } *a, &b
                        LOGGER.#{ m } *a, &b
                    end
                code
            end
        end
    end
end
