require 'rake/testtask'
#-----------------------------------------------------------------------
# Testing - this is either test or spec, include the appropriate one
#-----------------------------------------------------------------------
namespace :test do

    task :default => :test

    Rake::TestTask.new do |t| 
        t.libs      = <%= root.name.capitalize %>::SPEC.require_paths
    end

end
