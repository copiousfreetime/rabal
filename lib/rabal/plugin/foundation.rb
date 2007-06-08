require 'rabal'
require 'rubygems'
require 'main'

module Rabal
    module Plugin
        #
        # Base plugin that all other plugins will inherit from, but not
        # directly.  New plugins are declared with:
        #
        #   class NewPlugin < Rabal::Plugin::Base "/foo/bar"
        #   ...
        #   end
        #
        # This process uses GemPlugin under the covers, it has just been
        # wrapped to provide a different +Base+ class for everything to
        # inherit from.
        #
        class Foundation
            class << self

                # Called when another class inherits from Foundation.
                # when that happens that class is registered in the
                # GemPlugin::Manager
                def inherited(by_class)
                    register_key = "/" + by_class.to_s.downcase
                    GemPlugin::Manager.instance.register(register_as,register_key,by_class)
                    register_as = nil
                end

                # allows Plugin::Base to store the registration
                # information in the class variable.
                attribute :register_as => nil

                # part of the mini DSL for describing a Plugin
                def parameter(pname,description)
                    @parameters ||= {}
                    @parameters[pname] = [pname, description]
                end

                # get the parameters bac
                def parameters
                    @parameters
                end

                attribute :description =>  "A #{self.name} Without a Description"

            end
        end
    end

    #
    # This is the happen'n way to do things.  Camping does it,
    # GemPlugin does it.  Come on You can do it too.
    #
    # Put +register_path+ into the class variable @@path of
    # Plugin::Foundation and then return the Plugin::Foundation class
    # which will be used as the parent class for the new class.  
    #
    # Upon declaration of the new class, Foundation.inherited will be
    # invoked which will register the new class with GemPlugin::Manager
    # an clear out @@path 
    #
    def Plugin::Base(register_path)
        Plugin::Foundation.register_as = register_path
        Plugin::Foundation
    end
end
