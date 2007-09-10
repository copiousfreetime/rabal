#-----------------------------------------------------------------------
# Website maintenance
#-----------------------------------------------------------------------
namespace :site do

    desc "Update the website on #{Rabal::SPEC.remote_site_location}"
    task :deploy => :build do
        sh "rsync -zav --delete #{Rabal::SPEC.local_site_dir} #{Rabal::SPEC.remote_site_location}"
    end
    
    desc "Remove all the files from the local deployment of the site"
    task :clobber do
        rm_rf Rabal::SPEC.local_site_dir
    end
    
    if HAVE_WEBBY then
        desc "Build the public website"
        task :build do
            sh "pushd website && rake"
        end
    end

    if HAVE_HEEL then
        desc "View the website locally"
        task :view => :build do
            show_files Rabal::SPEC.local_site_dir
        end
    end

end
