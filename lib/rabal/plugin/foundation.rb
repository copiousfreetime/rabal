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

            # the PluginTree that the plugin creates.
            attr_reader :tree

            class << self

                # Called when another class inherits from Foundation.
                # when that happens that class is registered in the
                # GemPlugin::Manager
                def inherited(by_class)
                    register_key = "/" + by_class.to_s.downcase
                    by_class.register_path register_as
                    puts "registering #{register_as}, #{register_key}, #{by_class}"
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
                    @parameters ||= {}
                end

                def use_always?
                    @use_always
                end

                def use_always(d = true)
                    @use_always = d
                end

                attribute :description =>  "I Need a Description"
                attribute :register_path

                def use_name
                    name.split("::").last.dashify
                end
            end

            # A Plugin is instantiated and the options passed to it are
            # the results of the command line options for this plugin.
            #
            # The default action for any Plugin is to create a
            # PluginTree from its options utilizing the +register_path+
            # to determine a location within the gem's resources.  The
            # resources is used to instantiate a PluginTree and that is
            # set to +tree+ and by default, this tree will be 'mounted'
            # at the root of some other tree.
            def initialize(options = {})
                @parameters = OpenStruct.new(options)
                @tree = PluginTree.new(options,resource_by_name(my_main_tree_name),".")
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
                self.class.register_path.split("/").find{|p| p.length > 0}
            end

            # The main resource for this Plugin.  This is generally a
            # file or a directory that the plugin will use as a template
            # and create a PluginTree from.
            def my_main_tree_name
                tree_name = self.class.register_path.split("/").find_all {|p| p.length > 0}
                tree_name.shift
                tree_name.unshift "trees"
                tree_name.join("/")
            end

            # Access a resource utilized by the gem.  The name is the
            # path to a file or directory under the 'resources'
            # directory in the gem this plugin is a part of.
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
