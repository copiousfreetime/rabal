require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe Rabal::Plugin::Core do
    before(:each) do 
        @working_dir = my_temp_dir
        @before      = Dir.pwd
        @core        = Rabal::Plugin::Core.new({:project => "new-spec-proj", :author => "Foo Bar", :email => "foobar@example.com"})
        @base_tree   = Set.new(%w(README Rakefile CHANGES lib lib/new-spec-proj lib/new_spec_proj.rb lib/new-spec-proj/version.rb))
        Dir.chdir(@working_dir)
    end

    after(:each) do
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end
   
    it "should produce a ProjectTree" do
        @core.tree.should be_kind_of(ProjectTree)
    end

    it "should create a valid tree structure" do
        @core.tree.process
        find_in("new-spec-proj").sort.should == @base_tree.sort
    end

    it "should raise PluginParameterMissingError if missing information" do
        lambda {Rabal::Plugin::Core.new({})}.should raise_error(Rabal::PluginParameterMissingError)
    end

end
