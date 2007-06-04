module Rabal
    class Tree
        attr_accessor :node
        attr_accessor :parent
        attr_accessor :children

        def initialize
            @node = nil
            @parent = nil
            @children = []
        end

        def is_root?
            @parent.nil?
        end

        def root
            return self if is_root?
            return @parent.root
        end
    end

    class ProjectTree < Tree
    end
end
