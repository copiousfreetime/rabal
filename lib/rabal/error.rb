require 'rabal'

module Rabal
    class StandardError < ::StandardError; end
    class TemplateNotFoundError < Rabal::StandardError ; end 
    class PathNotFoundError < Rabal::StandardError ; end 
    class PluginParameterMissingError < Rabal::StandardError ; end
end

