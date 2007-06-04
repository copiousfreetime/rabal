require 'rabal/version'
require 'rabal/tree'

module Rabal
    AUTHOR          = "Jeremy Hinegardner".freeze
    AUTHOR_EMAIL    = "jeremy@hinegadner.org".freeze
    HOMEPAGE        = "http://copiousfreetime.rubyforge.org/rabal/"
    COPYRIGHT       = "2007 #{AUTHOR}".freeze
    DESCRIPTION     = <<DESC
Rabal is a commandline application for bootstrapping, packaging and
distributing ruby projects.
DESC

    APP_ROOT_DIR    = File.expand_path(File.join(File.dirname(__FILE__),".."))
    APP_LIB_DIR     = File.join(APP_ROOT_DIR,"lib").freeze
    APP_DATA_DIR    = File.join(APP_ROOT_DIR,"data").freeze

    class Application
        class << self
            def run(main)
                project_tree = ProjectTree.new(main.param.project)
                main.params.each do |p|
                    puts "#{p.name} #{p.value} #{p.given? ? "given" : "not given"}"
                    md = %r{\Awith-(.*)\Z}.match(p.name)
                    if md and p.given? then
                        project_tree << Tree.of_kind(md.captures.first).new(p.value)
                    end
                end
            end

            def validate_template_dirs(ary)
                ary.each do |d| 
                    check = File.expand_path(d)
                    raise Main::Parameter::InValid, "Template directory '#{d}' does not exist" if not File.exists?(check)
                end
                true
            end

        end
    end
end

