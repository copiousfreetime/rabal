require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe Rabal::Plugin::Spec do
    before(:each) do 
        @app         = Rabal.application
        @working_dir = my_temp_dir
        @before      = Dir.pwd
        @core        = Rabal::Plugin::Core.new({:project => "new-spec-proj", :author => "Foo Bar", :email => "foobar@example.com"})
        @base_tree   = Set.new(%w(README Rakefile CHANGES lib lib/new-spec-proj lib/new_spec_proj.rb lib/new-spec-proj/version.rb spec spec/new_spec_proj_spec.rb spec/spec_helper.rb lib/new-spec-proj/specification.rb lib/new-spec-proj/gemspec.rb tasks tasks/rspec.rake tasks/announce.rake tasks/distribution.rake tasks/documentation.rake tasks/setup.rb))
        Dir.chdir(@working_dir)
    end

    after(:each) do
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end
   
    it "should produce a valid bin directory and executable " do
        spec_plugin = Rabal::Plugin::Spec.new({})
        @core.tree << spec_plugin.tree
        @core.tree.process
        find_in("new-spec-proj").sort.should == @base_tree.sort
    end
end
