require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))

require 'find'
require 'set'
describe Rabal::PluginTree do
    before(:each) do 
        @working_dir = my_temp_dir
        @tree        = ProjectTree.new('new-spec-proj', {:author => "Some Author", :email => "author@example.com"})
        @tree        << PluginTree.new({:data1 => "some_data" },resource_handle("core"))

        @base_tree   = Set.new(%w(README Rakefile HISTORY lib lib/new-spec-proj lib/new_spec_proj.rb lib/new-spec-proj/version.rb gemspec.rb tasks tasks/utils.rb tasks/announce.rake tasks/distribution.rake tasks/documentation.rake tasks/config.rb))
    
        @before = Dir.pwd
        Dir.chdir(@working_dir)
    end

    after(:each) do 
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end

    it "should create a basic project" do
        @tree.process
        find_in("new-spec-proj").sort.should == @base_tree.sort
    end
    
    it "should allow for insertion into the Plugin Tree" do
        @tree << PluginTree.new({},resource_handle("test"),"test")
        @tree.process
        find_in('new-spec-proj').sort.should == (@base_tree +  %w(test test/tasks test/tasks/testunit.rake test/test test/test/new_spec_proj_test.rb test/test/test_helper.rb)).sort
    end

    it "should allow for insertion into the Plugin Tree somewhere other than the root" do
        d1 = DirectoryTree.new("misc")
        d1 << DirectoryTree.new("stuff")
        @tree << d1
        d1d2 = %w(misc misc/stuff)

        @tree.add_at_path("misc/stuff", PluginTree.new({},resource_handle("spec"),"subdir"))
        spec = %w(misc/stuff/subdir misc/stuff/subdir/spec/spec_helper.rb misc/stuff/subdir/spec/new_spec_proj_spec.rb misc/stuff/subdir/tasks/rspec.rake misc/stuff/subdir/spec misc/stuff/subdir/tasks)
        
        @tree.process
        find_in('new-spec-proj').sort.should == (@base_tree + d1d2 + spec).sort
    end

    it "should raise an exception if an attempt is made to add to a location that does not exist" do
        d = DirectoryTree.new("foo")
        d << DirectoryTree.new("bar")
        d.children["bar"] <<  DirectoryTree.new("baz")
        @tree << d
        lambda { @tree.add_at_path("foo/bar/blah", DirectoryTree.new("lkj")) }.should raise_error(PathNotFoundError)
    end
end
