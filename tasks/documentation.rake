#-----------------------------------------------------------------------
# Documentation
#-----------------------------------------------------------------------
namespace :doc do
    
    # generating documentation locally
    Rake::RDocTask.new do |rdoc|
        rdoc.rdoc_dir   = Rabal::SPEC.local_rdoc_dir
        rdoc.options    = Rabal::SPEC.rdoc_options 
        rdoc.rdoc_files = Rabal::SPEC.rdoc_files
    end

    desc "Deploy the RDoc documentation to #{Rabal::SPEC.remote_rdoc_location}"
    task :deploy => :rerdoc do
        sh "rsync -zav --delete #{Rabal::SPEC.local_rdoc_dir}/ #{Rabal::SPEC.remote_rdoc_location}"
    end

    if HAVE_HEEL then
        desc "View the RDoc documentation locally"
        task :view => :rdoc do
            sh "heel --root  #{Rabal::SPEC.local_rdoc_dir}"
        end
    end
end