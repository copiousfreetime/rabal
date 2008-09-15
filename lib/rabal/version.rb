require 'rabal'

module Rabal
  module Version
    MAJOR   = 0
    MINOR   = 3 
    BUILD   = 3

    def to_a
      [MAJOR, MINOR, BUILD]
    end

    def to_s
      to_a.join(".")
    end
    module_function :to_a
    module_function :to_s

    STRING = Version.to_s
  end 
  VERSION = Version.to_s
end

