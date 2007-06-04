require 'rabal/skeleton'

module Rabal
    VERSION         = [0,0,1].freeze
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
                skeleton = Skeleton.new(main.param.project)
                skeleton.attach(TestingSkeleton.new(main.prama["test-using"]))
                skeleton.attach(ExtensionSkeleton.new(main.param["extension"])) if main.param["extension"].given?
                puts "main.class => #{main.author}"
                main.params.each do |p|
                    puts "#{p.name} #{p.value}"
                end
            end
        end
    end
end

