require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe Rabal::Plugin::License do
    before(:each) do 
        @working_dir = my_temp_dir
        @before      = Dir.pwd
        @core        = Rabal::Plugin::Core.new({:project => "new-spec-proj", :author => "Foo Bar", :email => "foobar@example.com"})
        @base_tree   = Set.new(%w(README Rakefile CHANGES COPYING LICENSE lib lib/new-spec-proj lib/new_spec_proj.rb lib/new-spec-proj/version.rb lib/new-spec-proj/gemspec.rb lib/new-spec-proj/specification.rb tasks tasks/setup.rb tasks/announce.rake tasks/distribution.rake tasks/documentation.rake))
        Dir.chdir(@working_dir)
    end

    after(:each) do
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end
  
    # TODO: Change this to test that highline is used
    # it "should raise an error if the flavor is missing" do
    #   lambda { Rabal::Plugin::License.new({}) }.should raise_error(PluginParameterMissingError)
    # end

    it "should create a valid tree structure" do
        lic = Rabal::Plugin::License.new({:flavor => "BSD"})
        @core.tree << lic.tree
        @core.tree.process
        find_in("new-spec-proj").sort.should be_include("LICENSE")
    end

    it "should create a valid tree structure with COPYING and LICENSE for ruby" do
        lic = Rabal::Plugin::License.new({:flavor => "Ruby"})
        @core.tree << lic.tree
        @core.tree.process
        find_in("new-spec-proj").sort.should == @base_tree.sort
    end


    # TODO: change this to make sure that highline is used
    #it "should raise an error if the flavor is incorrect" do
    #    lambda { Rabal::Plugin::License.new({:flavor => "BLAH"}) }.should raise_error(PluginParameterMissingError)
    #end

end
