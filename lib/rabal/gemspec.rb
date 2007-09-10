require 'rubygems'
require 'rabal/specification'
require 'rabal/version'
require 'rake'

module Rabal
    SPEC = Rabal::Specification.new do |spec|
                spec.name               = "rabal"
                spec.version            = Rabal::VERSION
                spec.rubyforge_project  = "copiousfreetime"
                spec.author             = "Jeremy Hinegardner"
                spec.email              = "jeremy@hinegardner.org"
                spec.homepage           = "http://copiousfreetime.rubyforge.org/rabal/"

                spec.summary            = "A tool for bootstrapping project development"
                spec.description        = <<-DESC
                Ruby Architecture for Building Applications and
                Libraries.

                Rabal is a commandline application for bootstrapping,
                packaging and distributing ruby projects.
                DESC

                spec.extra_rdoc_files   = FileList["[A-Z]*"] - FileList["TODO"]
                spec.has_rdoc           = true
                spec.rdoc_main          = "README"
                spec.rdoc_options       = [ "--line-numbers" , "--inline-source" ]

                spec.test_files         = FileList["spec/**/*.rb"]
                spec.executable         = spec.name
                spec.files              = spec.test_files + spec.extra_rdoc_files + 
                                          FileList["lib/**/*.rb", "resources/**/*"]

                spec.add_dependency("main", ">= 0.0.2")
                spec.add_dependency("gem_plugin", ">= 0.2.1")
                spec.add_dependency("highline", ">= 1.2.9")
                spec.required_ruby_version  = ">= 1.8.5"

                spec.platform           = Gem::Platform::RUBY

                spec.remote_user        = "jjh"
                spec.local_rdoc_dir     = "doc/rdoc"
                spec.remote_rdoc_dir    = ""
                spec.local_coverage_dir = "doc/coverage"

                spec.remote_site_dir    = ""

           end
end


