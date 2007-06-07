require 'ostruct'
module Rabal
    #
    # A customized version of OpenStruct to provide additional access
    # methods
    #
    class OpenStruct < ::OpenStruct

        # access the items in the internal hash by key
        def [](key)
            self.send(key)
        end

        def []=(key,value)
            self.send(key,value)
        end

        def keys
            @table.keys
        end
    end
end
