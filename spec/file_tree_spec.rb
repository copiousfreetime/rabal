require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe FileTree do
    before(:each) do 
        dir_template = File.join(Dir.tmpdir,"directory-tree-spec.XXXX")
        @working_dir = MkTemp.mktempdir(dir_template)
        @before      = Dir.pwd
        @tree        = DirectoryTree.new("spec-test")
        Dir.chdir(@working_dir)
    end

    after(:each) do
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end
    
    it "should create a file under the under the working directory" do
        @tree << FileTree.new("testfile.txt")
        @tree.process
        f = File.join(@working_dir,"spec-test","testfile.txt")
        File.file?(f).should == true
    end

    it "should skip the file if it doesn't exist" do
        fname = File.join(@working_dir,"testfile.txt")
        File.open(fname,"w+") { |f| f.write("FileTree spec") }
        tree = FileTree.new("testfile.txt")
        tree.process
        line = IO.read(fname)
        line.should == "FileTree spec"
    end
end
