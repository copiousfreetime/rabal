require 'rubygems'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'
require 'spec/rake/spectask'

$: << File.join(File.dirname(__FILE__),"lib")

require 'rabal'

task :default => :spec

# since we have directories named 'core' wipe out what CLEAN has
CLEAN.exclude("**/core")

#-----------------------------------------------------------------------
# Packaging and Installation
#-----------------------------------------------------------------------
SPEC = Gem::Specification.new do |s|
    s.name               = "rabal"
    s.author             = Rabal::AUTHOR
    s.email              = Rabal::AUTHOR_EMAIL
    s.homepage           = Rabal::HOMEPAGE
    s.summary            = "A tool for bootstrapping project development"
    s.platform           = Gem::Platform::RUBY
    s.description        = Rabal::DESCRIPTION

    s.extra_rdoc_files   = %w[LICENSE README COPYING README.PLUGIN]
    s.files              = FileList["lib/**/*", "resources/**/*","bin/**/*"]
    s.test_files         = FileList["spec/**/*"]
    s.has_rdoc           = true
    s.rdoc_options       << [ "--line-numbers" , "--inline-source", 
                            "--title", "Rabal -- Ruby Architecture for Building Applications and Libraries",
                             "--main", "README" ]

    s.rubyforge_project  = "copiousfreetime"
    s.version            = Gem::Version.create("0.0.1")
    s.add_dependency("main", ">= 0.0.2")
    s.add_dependency("gem_plugin", ">= 0.2.1")
    s.executables        = %w[ rabal ]
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

#-----------------------------------------------------------------------
# Documentation and Testing (rspec)
#-----------------------------------------------------------------------
rd = Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir   = "doc/rdoc"
    rdoc.title      = SPEC.summary
    rdoc.main       = "README"
    rdoc.rdoc_files = (FileList["lib/**/*","bin/**/*"]+ SPEC.extra_rdoc_files).uniq
end

rspec = Spec::Rake::SpecTask.new do |r|
    r.rcov      = true
    r.rcov_dir  = "doc/coverage"
    r.libs      = SPEC.require_paths
    r.spec_opts = %w(--format specdoc)
end

#-----------------------------------------------------------------------
# if we are in the project source code control sandbox then there are
# other tasks available.
#-----------------------------------------------------------------------
if File.directory?("_darcs") then
    require 'tasks/rubyforge'
end

