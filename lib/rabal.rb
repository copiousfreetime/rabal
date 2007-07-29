require 'find'
require 'erb'
require 'logger'
require 'ostruct'

require 'rubygems'
require 'main'

module Rabal

    ROOT_DIR        = File.expand_path(File.join(File.dirname(__FILE__),".."))
    LIB_DIR         = File.join(ROOT_DIR,"lib").freeze
    KNOWN_WORDS     = {
        "rabal.project" => lambda { |tree| tree.root.project_name }
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
require 'rabal/gemspec'
require 'rabal/logger'
require 'rabal/plugin'
require 'rabal/plugin_tree'
require 'rabal/project_tree'
require 'rabal/specification'
require 'rabal/tree'
require 'rabal/usage'
require 'rabal/util'
require 'rabal/version'
