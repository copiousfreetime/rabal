require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper.rb"))
describe Rabal::ActionTree do
    before(:each) do 
        @tree = ActionTree.new("root")
    end
    it "should have a before_action" do
        @tree.respond_to?("before_action").should == true
    end
    it "should have an after_action" do
        @tree.respond_to?("after_action").should == true
    end

    it "should raise exception on action" do
        lambda { @tree.action }.should raise_error(NotImplementedError)
    end

    it "should walk all the children" do
        tree = ValidatingActionTree.new("root")
        3.times do |i|
            tree << ValidatingActionTree.new("child #{i}")
        end
        2.times do |i|
            tree.children["child 1"] << ValidatingActionTree.new("grandchild #{i}")
        end
        tree.process
        ValidatingActionTree.action_count.should == 6
    end
end
