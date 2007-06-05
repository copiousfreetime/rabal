require 'rabal/tree'

module Rabal
    class ActionTree < Tree
        
        def initialize(data)
            super(data)
        end

        def before_action
        end

        def action
            raise NotImplementedError, "Oops, forgot to implement 'action'"
        end

        def after_action 
        end

        # 
        # Walk the tree recursively processing each subtree.  The
        # process is:
        #  
        # * execute before_action
        # * execute action
        # * process each child
        # * execute after_action
        #  
        #
        def process
            before_action

            action

            children.each do |child|
                child.process
            end

            after_action
        end
    end 
end
