require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))

require 'find'
require 'set'
describe Rabal::ProjectTree do
    before(:each) do 
        @working_dir = my_temp_dir
        @tree        = ProjectTree.new("new-spec-proj","rabal:base")
        @tree.build

        @base_tree   = Set.new(%w(README LICENSE Rakefile CHANGES INSTALL lib lib/new-spec-proj lib/new-spec-proj/version.rb))
    
        @before = Dir.pwd
        Dir.chdir(@working_dir)
    end

    after(:each) do 
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end

    it "should create a basic project" do
        @tree.process
        find_in("new-spec-proj").should == @base_tree
    end

    it "should allow for insertion into the Project Tree" do
        @tree << ProjectTree.new("test","rabal:test")
        @tree.process
        find_in('new-spec-proj').sort.should == (@base_tree +  %w(test test/new_spec_proj_test.rb test/test_helper.rb)).sort
    end
end
