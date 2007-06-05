require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe DirectoryTree do
    before(:each) do 
        dir_template = File.join(Dir.tmpdir,"directory-tree-spec.XXXX")
        @working_dir = MkTemp.mktempdir(dir_template)
        @before      = Dir.pwd
        Dir.chdir(@working_dir)
    end

    after(:each) do
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end
    
    it "should create a directory under the working directory" do
        dir_tree    = DirectoryTree.new("spec-test")
        dir_tree.process
        File.directory?(File.join(@working_dir,"spec-test")).should == true
    end

    it "should do nothing if the directory already exists" do
        d = File.join(@working_dir,"spec-test")
        Dir.mkdir(d)
        dir_tree = DirectoryTree.new("spec-test")
        x = File.directory?(d)
        dir_tree.process
        File.directory?(d).should == x
    end
end
