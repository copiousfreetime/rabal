require 'ostruct'
require 'main'
module Rabal
    module Util
        def replace_known_words(str)
            KNOWN_WORDS.each_pair do |word, call_me|
                if str.index(word) then
                    str = str.gsub(word,call_me.call(self))
                end
            end
            str
        end
    end
end

class String

    def underscore
        partition.join("_")
    end

    def dashify
        partition.join('-')
    end

    def camelize
        partition.collect { |c| c.capitalize }.join("")
    end

    private

    # split the string up into pieces based on underscores, dashes or
    # camel case.  An array is returned that has all the items partition
    # and all in lower case
    def partition
        case self
        when /-/
            split_on = "-"
        when /_/
            split_on = "_"
        when /[^A-Z][A-Z]/
            split_on = /([^A-Z]*)()([A-Z][^A-Z]+)/
        else
            return [self]
        end
        self.split(split_on).find_all { |c| c.size > 0 }.collect { |c| c.downcase }
    end
end

module Main
    class Parameter
        # slight alteration to the default synopsis 
        class Option
            def short_synopsis
                long, *short = names
                value = cast || name 
                rhs = argument ? (argument == :required ? "=#{ name }" : "=[#{ name }]") : nil 
                label = ["--#{ long }#{ rhs }", short.map{|s| "-#{ s }"}].flatten.join(", ")
            end 
        end 
    end
end
