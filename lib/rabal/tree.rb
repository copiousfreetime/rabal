require 'rabal'

module Rabal
    #
    # A basic Tree structure
    #
    class Tree

        include Enumerable

        # The name of this Tree
        attr_accessor :name

        # The parent of this node.  If this is nil then this Tree is a
        # root.
        attr_accessor :parent

        # The children of this node.  If this Array is empty, then this
        # Tree is a leaf.
        attr_accessor :children

        #
        # Create a new Tree with the given object.to_s as its +name+.
        #
        def initialize(name)
            @name       = name.to_s
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
        # Return the distance from the root
        #
        def depth
            return 0 if is_root?
            return (1 + @parent.depth)
        end

        #
        # Add the given object to the Tree as a child of this node.  If
        # the given object is not a Tree then wrap it with a Tree.
        #
        def <<(obj)
            if not obj.kind_of?(Tree) then
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
        # Count how many items are in the tree
        #
        def size
            inject(0) { |count,n| count + 1 }
        end
        
        # 
        # Walk the tree in a depth first manner, visiting the Tree
        # first, then its children
        #
        def walk(tree,method)
            method.call(tree)
            tree.children.each do |child|
                walk(child,method) 
            end
        end

        # 
        # Allow for a method call to cascade up the tree looking for a
        # Tree that responds to the call.
        #
        def method_missing(method_id,*params,&block)
            if not is_root? then
                @parent.send method_id, *params, &block
            else
                raise NoMethodError, "undefined method `#{method_id}' for #{name}:Tree"
            end
        end

        #
        # 
        private

        #
        # Log to the Rabal::Log padding the message with 2 spaces *
        # depth.
        #
        %w(debug info warn error fatal).each do |m|
            class_eval <<-code
                def #{ m }(msg)
                    msg = ("  " * depth) +  msg
                    Rabal::Log.#{ m }(msg)
                end
            code
        end
    end
end
