require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe Rabal::Plugin::Test do
    before(:each) do 
        @app         = Rabal.application
        @working_dir = my_temp_dir
        @before      = Dir.pwd
        @core        = Rabal::Plugin::Core.new({:project => "new-spec-proj", :author => "Foo Bar", :email => "foobar@example.com"})
        @base_tree   = Set.new(%w(README Rakefile HISTORY lib lib/new-spec-proj lib/new_spec_proj.rb lib/new-spec-proj/version.rb test test/new_spec_proj_test.rb test/test_helper.rb gemspec.rb tasks tasks/testunit.rake tasks/announce.rake tasks/distribution.rake tasks/documentation.rake tasks/config.rb tasks/utils.rb ))
        Dir.chdir(@working_dir)
    end

    after(:each) do
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end
   
    it "should produce a valid bin directory and executable " do
        test_plugin = Rabal::Plugin::Test.new({})
        @core.tree << test_plugin.tree
        @core.tree.process
        find_in("new-spec-proj").sort.should == @base_tree.sort
    end
end
