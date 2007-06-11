require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe ProjectTree do
    before(:each) do 
        @proj_tree = ProjectTree.new("spec-test",{ :author => "Foo Bar",:email => "foo@example.com"})
        @working_dir = my_temp_dir
        @before      = Dir.pwd
        Dir.chdir(@working_dir)
    end

    after(:each) do
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end

    it "should have a project name" do
        @proj_tree.project_name.should == "spec-test"
    end
    
    it "should have an author " do
        @proj_tree.author.should == "Foo Bar"
    end
    
    it "should have an email " do
        @proj_tree.email.should == "foo@example.com"
    end
    
    it "should create a project under the working directory" do
        @proj_tree.process
        File.directory?(File.join(@working_dir,"spec-test")).should == true
    end

    it "should do nothing if the Project already exists" do
        d = File.join(@working_dir,"spec-test")
        Dir.mkdir(d)
        x = File.directory?(d)
        @proj_tree.process
        File.directory?(d).should == x
    end
end
