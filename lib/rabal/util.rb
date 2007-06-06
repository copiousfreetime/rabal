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