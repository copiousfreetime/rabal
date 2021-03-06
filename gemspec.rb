require 'rubygems'
require 'rabal/version'
require 'tasks/config'

Rabal::GEM_SPEC = Gem::Specification.new do |spec|
  proj = Configuration.for('project')
  spec.name         = proj.name
  spec.version      = Rabal::VERSION
  
  spec.author       = proj.author
  spec.email        = proj.email
  spec.homepage     = proj.homepage
  spec.summary      = proj.summary
  spec.description  = proj.description
  spec.platform     = Gem::Platform::RUBY

  
  pkg = Configuration.for('packaging')
  spec.files        = pkg.files.all
  spec.executables  = pkg.files.bin.collect { |b| File.basename(b) }

  # add dependencies here
  spec.add_dependency("configuration", ">= 0.0.5")
  spec.add_dependency("rake", ">= 0.8.1")
  spec.add_dependency("main", ">= 2.8.1")
  spec.add_dependency("gem_plugin", ">= 0.2.1")
  spec.add_dependency("highline", ">= 1.2.9")
  spec.add_dependency("fattr", ">= 1.0.3")
   
  
  if rdoc = Configuration.for_if_exist?('rdoc') then
    spec.has_rdoc         = true
    spec.extra_rdoc_files = pkg.files.rdoc
    spec.rdoc_options     = rdoc.options + [ "--main" , rdoc.main_page ]
  else
    spec.has_rdoc         = false
  end 

  if test = Configuration.for_if_exist?('testing') then
    spec.test_files       = test.files
  end 

  if rf = Configuration.for_if_exist?('rubyforge') then
    spec.rubyforge_project  = rf.project
  end 

end
