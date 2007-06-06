require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))

describe Tree do
    before(:each) do 
        @tree = Tree.new("root")
        @blank_tree = Tree.new("blank")
        @tree_with_leaves = Tree.new("root")
        @tree_with_leaves << Tree.new("c1")
        @tree_with_leaves << Tree.new("c2")
        
        @tree_with_leaves.children["c1"] << Tree.new("c1-c1")
        subtree = Tree.new("c1-c2")
        subtree << Tree.new("c1-c2-c1")
        subtree << Tree.new("c1-c2-c2")
        subtree << Tree.new("c1-c2-c3")
        @tree_with_leaves.children['c1'] << subtree
        @tree_with_leaves.children["c1"] << Tree.new("c1-c3")
        @tree_with_leaves.children["c2"] << Tree.new("c2-c1")
        @tree_with_leaves.children["c1"] << Tree.new("c2-c2")
    end

    it "should say if it is root" do
        @tree.should be_is_root
    end
    
    it "should say if it is a leaf" do
        @tree.should be_is_leaf
    end

    it "should have 0 children when created" do
        @blank_tree.children.should have(0).items
    end

    it "should not have a parent when created" do
        @blank_tree.parent.should be_nil
    end

    it "should wrap children as Tree" do
        @tree << "child 1"
        @tree.children["child 1"].should be_kind_of(Tree)
    end
    
    it "should wrap children as Tree and data should give access to the original" do
        @tree << "child 1"
        @tree.children["child 1"].name.should == "child 1"
    end

    it "should only wrap children as Tree's if they are not already" do
        @tree << Tree.new("child 1")
        @tree.children["child 1"].name.should_not be_kind_of(Tree)
    end

    it "should be able to accept children" do
        @tree << "child 1"
        @tree << "child 2"
        @tree.children.should have(2).items
    end

    it "should have the children return the parent as the root" do
        child = Tree.new('child 1')
        @tree << child
        child.root.should == @tree
    end
    
    it "should have a size (number of nodes)" do
        @tree_with_leaves.size.should == 11
    end

    it "should be iteratable" do
        @tree_with_leaves.collect { |n| n.name }.size.should == 11
    end

    it "should say how deep an item is in the tree" do
        @tree_with_leaves.children["c1"].children["c1-c1"].depth.should == 2
    end

    it "should cascade a method call up the tree" do

    end
end
