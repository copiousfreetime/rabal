require File.expand_path(File.join(File.dirname(__FILE__),"spec_helper"))

describe "Utility functions" do
    before(:each) do
        @camel_before = %w(thisIsCamelCase ThisIsCamelCase IDoNotWantThis README Core)
        @camel_final = %w(ThisIsCamelCase ThisIsCamelCase IDoNotWantThis Readme Core)

        @dashed_before = %w(this-is-camel-case this-Is-camel-case i-do-nOt-want-this README core)
        @dashed_final = %w(this-is-camel-case this-is-camel-case i-do-not-want-this README core)
        
        @underscores_before = %w(this_is_Camel_Case this_is_caMel_case i_do_not_want_thiS README core)
        @underscores_final = %w(this_is_camel_case this_is_camel_case i_do_not_want_this README core)
    end

    it "should convert camel case to dashified" do
        r = @camel_before.collect { |c| c.dashify }
        r.should == @dashed_final
    end
    
    it "should convert camel case to underscores" do
        r = @camel_before.collect { |c| c.underscore }
        r.should == @underscores_final
    end

    it "should convert dashes to underscores" do
        r = @dashed_before.collect { |c| c.underscore }
        r.should == @underscores_final
    end
    
    it "should convert dashes to camel" do
        r = @dashed_before.collect { |c| c.camelize }
        r.should == @camel_final
    end
    
    it "should convert underscores to camel" do
        r = @underscores_before.collect { |c| c.camelize }
        r.should == @camel_final
    end

    it "should convert underscores to dashes" do
        r = @underscores_before.collect { |c| c.dashify }
        r.should == @dashed_final
    end




end
