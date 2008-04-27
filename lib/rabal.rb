
require 'find'
require 'erb'
require 'logger'
require 'ostruct'

require 'rubygems'
require 'main'

module Rabal
  # The root directory of the project is considered to be the parent directory
  # of the 'lib' directory.
  #   
  # returns:: [String] The full expanded path of the parent directory of 'lib'
  #           going up the path from the current file.  Trailing
  #           File::SEPARATOR is guaranteed.
  #   
  def self.root_dir
    unless @root_dir
      path_parts = ::File.expand_path(__FILE__).split(::File::SEPARATOR)
      lib_index  = path_parts.rindex("lib")
      @root_dir = path_parts[0...lib_index].join(::File::SEPARATOR) + ::File::SEPARATOR
    end 
    return @root_dir
  end 

  # returns:: [String] The full expanded path of the +config+ directory
  #           below _root_dir_.  All parameters passed in are joined onto the
  #           result.  Trailing File::SEPARATOR is guaranteed if _args_ are
  #           *not* present.
  #   
  def self.config_path(*args)
    self.sub_path("config", *args)
  end 

  # returns:: [String] The full expanded path of the +resource+ directory below
  #           _root_dir_.  All parameters passed in are joined onto the 
  #           result. Trailing File::SEPARATOR is guaranteed if 
  #           _*args_ are *not* present.
  #   
  def self.resource_path(*args)
    self.sub_path("resources", *args)
  end 

  # returns:: [String] The full expanded path of the +lib+ directory below
  #           _root_dir_.  All parameters passed in are joined onto the 
  #           result. Trailing File::SEPARATOR is guaranteed if 
  #           _*args_ are *not* present.
  #   
  def self.lib_path(*args)
    self.sub_path("lib", *args)
  end 

  def self.sub_path(sub,*args)
    sp = ::File.join(root_dir, sub) + File::SEPARATOR
    sp = ::File.join(sp, *args) if args
  end 

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
require 'rabal/logger'
require 'rabal/plugin'
require 'rabal/plugin_tree'
require 'rabal/project_tree'
require 'rabal/tree'
require 'rabal/usage'
require 'rabal/util'
require 'rabal/version'
