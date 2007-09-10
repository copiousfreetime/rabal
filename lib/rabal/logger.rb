require 'rabal'

module Rabal
    module Log
        class << self
            def logger
                return @logger if @logger
                @logger = ::Logger.new($stdout)
                @logger.datetime_format ="%Y-%m-%d %H:%M:%S"
                @logger
            end

            def logger=(log)
                @logger = ::Logger.new(log)
                @logger.datetime_format ="%Y-%m-%d %H:%M:%S"
                @logger
            end
            %w(debug info warn error fatal).each do |m|
                module_eval <<-code 
                    def #{ m } *a, &b
                        logger.#{ m } *a, &b
                    end
                code
            end
        end
    end
end
