require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
describe FileTree do
    before(:each) do 
        @template_file_name = File.expand_path(File.join(File.dirname(__FILE__),"file_dir_template.txt.erb"))
        @working_dir = my_temp_dir
        @tree        = DirectoryTree.new("spec-test")
        @template = "my name is : <%= file_name %>"
        
        @before      = Dir.pwd
        Dir.chdir(@working_dir)
    end

    after(:each) do
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end
    
    it "should create a file under the under the working directory" do
        @tree << FileTree.new("testfile.txt",@template)
        @tree.process
        f = File.join(@working_dir,"spec-test","testfile.txt")
        line = IO.read(f)
        line.should == "my name is : testfile.txt"
    end

    it "should skip the file if it doesn't exist" do
        fname = File.join(@working_dir,"testfile.txt")
        File.open(fname,"w+") { |f| f.write("FileTree spec") }
        tree = FileTree.new("testfile.txt",@template)
        tree.process
        line = IO.read(fname)
        line.should == "FileTree spec"
    end

    it "should process a file via ERB, calling parent methods if necessary" do
        @tree << FileTree.from_file(@template_file_name)
        @tree.process
        line = IO.read(File.join(@working_dir,"spec-test","file_dir_template.txt")).chomp
        line.should == "My name is : 'file_dir_template.txt' and I live in 'spec-test'"
    end

    it "should raise method missing if the nothing in the tree has the method" do
        f = FileTree.from_file(@template_file_name)
        @tree << f
        lambda { f.oops }.should raise_error(NoMethodError)
    end

end
