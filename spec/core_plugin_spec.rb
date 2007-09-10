require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe Rabal::Plugin::Core do
    before(:each) do 
        @working_dir = my_temp_dir
        @before      = Dir.pwd
        @core        = Rabal::Plugin::Core.new({:project => "new-spec-proj", :author => "Foo Bar", :email => "foobar@example.com"})
        @base_tree   = Set.new(%w(README Rakefile CHANGES lib lib/new-spec-proj lib/new_spec_proj.rb lib/new-spec-proj/version.rb lib/new-spec-proj/specification.rb lib/new-spec-proj/gemspec.rb tasks tasks/setup.rb tasks/announce.rake tasks/distribution.rake tasks/documentation.rake))
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

    it "the tree should have author and email" do
        @core.tree.process
        @core.tree.author.should == "Foo Bar"
        @core.tree.email.should == "foobar@example.com"
    end

    # TODO: test to make sure that highline is used
    # it "should raise PluginParameterMissingError if missing information" do
    #   lambda {Rabal::Plugin::Core.new({})}.should raise_error(Rabal::PluginParameterMissingError)
    # end

end
