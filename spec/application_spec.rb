require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))
require 'rabal/application'
require 'stringio'

describe Rabal::Application do
    before(:each) do 
        @working_dir = my_temp_dir
        @before      = Dir.pwd
        @base_tree   = Set.new(%w[README Rakefile HISTORY LICENSE 
                                  lib lib/spec-proj lib/spec_proj.rb lib/spec-proj/version.rb gemspec.rb
                                  tasks tasks/announce.rake tasks/distribution.rake tasks/documentation.rake tasks/config.rb tasks/utils.rb ])
        @stdin       = StringIO.new
        @stdout      = StringIO.new
        @stderr      = StringIO.new
        
        Dir.chdir(@working_dir)
       
        # this must come after chdir
        @application = Rabal::Application.new(@stdin,@stdout,@stderr)
      
        Rabal.application = @application
    end

    after(:each) do 
        Dir.chdir(@before)
        FileUtils.rm_rf @working_dir
    end

     it "should have a good default tree " do
         begin
             @application.run(%w[--core-author=Testing --core-email=testing@example.com --license-flavor=mit spec-proj])
         rescue SystemExit => se
             se.status.should == 0
             find_in("spec-proj").sort.should == @base_tree.sort
         end
     end
    
    it "should exit 1 on --help" do
        begin
            @application.run(%w[--help])
        rescue SystemExit => se
            se.status.should == 1
        end
    end

    it "should output to stderr on bad parameters" do
        begin
            @application.run(%w[--blah])
        rescue SystemExit => se
            se.status.should == 1
            #@stderr.string.should =~ /unrecognized option `--blah'/m
        end
    end

    it "should have allow for plugin options" do
        begin
            @application.run(%w[--use-all --help])
        rescue SystemExit => se
            se.status.should == 1
        end
    end 
end

