require 'find'
require 'erb'
require 'logger'
require 'ostruct'

require 'rubygems'
require 'main'

module Rabal
    AUTHOR          = "Jeremy Hinegardner".freeze
    AUTHOR_EMAIL    = "jeremy@hinegardner.org".freeze
    HOMEPAGE        = "http://copiousfreetime.rubyforge.org/rabal/"
    COPYRIGHT       = "2007 #{AUTHOR}".freeze
    DESCRIPTION     = <<DESC
Ruby Architecture for Building Applications and Libraries.

Rabal is a commandline application for bootstrapping, packaging and
distributing ruby projects.
DESC

    ROOT_DIR        = File.expand_path(File.join(File.dirname(__FILE__),".."))
    LIB_DIR         = File.join(ROOT_DIR,"lib").freeze
    KNOWN_WORDS     = {
        "rabal.project" => lambda { |tree| tree.root.name }
    }

    #
    # Module singleton methods, allow for accessing a single rabal
    # application from anywhere
    #
    class << self
        def application
            @application ||= Rabal::Application.new
        end

        def application=(app)
            @application = app
        end
    end
end

# require all the files
require 'rabal/action_tree'
require 'rabal/application'
require 'rabal/directory_tree'
require 'rabal/error'
require 'rabal/file_tree'
require 'rabal/logger'
require 'rabal/plugin'
require 'rabal/plugin_tree'
require 'rabal/project_tree'
require 'rabal/tree'
require 'rabal/usage'
require 'rabal/util'
require 'rabal/version'
