require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
require 'rabal/application'
require 'stringio'

describe Rabal::Application do
    before(:each) do 
        @working_dir = my_temp_dir
        @before      = Dir.pwd
        @base_tree   = Set.new(%w(README Rakefile CHANGES LICENSE lib lib/spec-proj lib/new_spec_proj.rb lib/spec-proj/version.rb))
        @stdin       = StringIO.new
        @stdout      = StringIO.new
        @stderr      = StringIO.new
        @application = Rabal::Application.new(@stdin,@stdout,@stderr)
        Dir.chdir(@working_dir)
    end

    after(:each) do 
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end

    it "should exit 0 on --help" do
        begin
            @application.run(%w[--help])
        rescue SystemExit => se
            se.status.should == 0
        end
    end

    it "should output to stderr on bad parameters" do
        begin
            @application.run(%w[--blah])
        rescue SystemExit => se
            se.status.should == 1
            @stderr.string.should =~ /unrecognized option `--blah'/m
        end
    end

    it "should have allow for plugin options" do
        begin
            @application.run(%w[--use-all --help])
        rescue SystemExit => se
            se.status.should == 0
        end
    end 
end

