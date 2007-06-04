module Rabal
    class Tree

        include Enumerable

        # The data contained within this Tree
        attr_accessor :data

        # The parent of this node.  If this is nil then this Tree is a
        # root.
        attr_accessor :parent

        # The children of this node.  If this Array is empty, then this
        # Tree is a leaf.
        attr_accessor :children

        #
        # Create a new Tree with the give object as its +data+ payload.
        #
        def initialize(obj)
            @data       = obj
            @parent     = nil
            @children   = []
            return self
        end


        #
        # Return true if this Tree has no children.
        #
        def is_leaf?
            @children.empty?
        end

        # 
        # Return true if this Tree has no parent.
        #
        def is_root?
            @parent.nil?
        end

        # 
        # Return the root node of the tree
        #
        def root
            return self if is_root?
            return @parent.root
        end

        #
        # Add the given object to the Tree as a child of this node.  If
        # the given object is not a Tree then wrap it with a Tree.
        #
        def <<(obj)
            if not obj.kind_of?(self.class) then
                obj = Tree.new(obj)
            end
            obj.parent = self
            @children << obj
            return self
        end

        #
        # Allow for Enumerable to be included.  This just wraps walk.
        #
        def each
            self.walk(self,lambda { |tree| yield tree }) 
        end

        #
        # Walk the tree yielding the data items in each node
        #
        def each_datum
            self.walk(self,lambda { |tree| yield tree.data }) 
        end
        #
        # Count how many items are in the tree
        #
        def size
            inject(0) { |count,n| count + 1 }
        end
        
        # 
        # Walk the tree in a depth first manner
        #
        def walk(tree,method)
            tree.children.each do |child|
                walk(child,method) 
            end
            method.call(tree)
        end
    end
end