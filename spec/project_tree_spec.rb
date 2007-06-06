require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))

require 'find'
describe Rabal::ProjectTree do
    before(:each) do 
        @working_dir = my_temp_dir
        @tree        = ProjectTree.new("new-spec-proj","rabal:base")
        @base_tree   = %w(README LICENSE Rakefile CHANGES INSTALL lib lib/new-spec-proj lib/new-spec-proj/version.rb)
        @base_tree.sort!
    
        @before = Dir.pwd
        Dir.chdir(@working_dir)
    end

    after(:each) do 
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end

    it "should create a basic project" do
        @tree.process
        found = find_in("new-spec-proj")
        found.should == @base_tree 
    end

    it "should allow for insertion into the Project Tree" do
        @tree << ProjectTree.new("test","rabal:test")
        @tree.process
    end
end
