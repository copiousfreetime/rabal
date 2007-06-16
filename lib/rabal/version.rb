require 'rabal'

module Rabal
    class Version
        MAJOR   = 0 
        MINOR   = 0 
        TINY    = 1 

        class << self
            def to_a
                [MAJOR, MINOR, TINY]
            end

            def to_s
                to_a.join(".")
            end
            
            def to_gem_version
                ::Gem::Version.create(VERSION)
            end
        end
    end 
    VERSION = Version.to_s
end

