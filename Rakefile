require 'rubygems'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'
require 'spec/rake/spectask'

$: << File.join(File.dirname(__FILE__),"lib")

SPEC = Gem::Specification.new do |s|
    s.name               = "rabal"
    s.author             = "Jeremy Hinegardner"
    s.email              = "jeremy@hinegardner.org"
    s.homepage           = "http://copiousfreetime.rubyforge.org/rabal/"
    s.summary            = "A tool for bootstrapping project development"
    s.description        =<<-DESC
    Ruby Architecture for Building Applications and Libraries. 

    A tool for bootstrapping project development 
    DESC

    s.extra_rdoc_files   = FileList["README", "LICENSE"]
    s.files              = FileList["lib/**/*", "spec/**/*","data/**/*","bin/**/*"]
    s.has_rdoc           = true
    s.rdoc_options       << [ "--line-numbers" , "--inline-source", "--title", s.summary,
                             "--main", "README" ]

    s.rubyforge_project  = "copiousfreetime"
    s.version            = Gem::Version.create("0.0.1")
    s.add_dependency("rspec")
end

task :default => :spec

rd = Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir   = "doc/rdoc"
    rdoc.title      = SPEC.summary
    rdoc.main       = "README"
    rdoc.rdoc_files = SPEC.files + SPEC.extra_rdoc_files
end

packaging = Rake::GemPackageTask.new(SPEC) do |pkg|
    pkg.need_tar = true
    pkg.need_zip = true
end


desc "Install as a gem"
task :install_gem => [:clobber, :package] do
    sh "sudo gem install pkg/*.gem"
end

desc "Dump gemspec"
task :gemspec do
    puts SPEC.to_ruby
end

rspec = Spec::Rake::SpecTask.new do |r|
    r.libs      = SPEC.require_paths
    r.spec_opts = %w(--format specdoc)
end
