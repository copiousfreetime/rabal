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
                    by_class.register_path register_as
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

                def use_always?
                    @use_always
                end

                def use_always(d = true)
                    @use_always = d
                end

                attribute :register_path
                attribute :description =>  "I Need a Description"

                def use_name
                    name.split("::").last.dashify
                end
            end

            ############################################################
            # regular instance methods, provide for convenience to the
            # child plugins
            ############################################################


            # What gem a plugin belongs to.  This is necessary to access
            # the resources of the gem the plugin may use.  Overload
            # this in a child plugin to return what you want.  By
            # default it uses the first part of the path the gem is
            # registered under.
            #
            # That is when the plugin is defined
            #
            #   class MyPlugin < Rabal::Plugin::Base "/my-plugin/something"
            #   ...
            #   end
            #
            # 'my-plugin' is defined as being the default gem name.
            def my_gem_name
                register_path.split("/").find{|p| p.length > 0}
            end

            # access a resource in the 
            def resource_by_name(resource_name)
                Rabal.application.plugin_resource(my_gem_name,resource_name)
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
