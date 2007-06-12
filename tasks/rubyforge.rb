#-----------------------------------------------------------------------
# create the website for use on rubyforge
#
#   The website includes the rdoc and the coverage report.
#   
#   Ripped from the guts of hoe
#-----------------------------------------------------------------------
# generate the content for the website
task :publish_docs => [:rdoc, :spec]

# push the website and all documentation to rubyforge
require 'yaml'
PUBLISH_DIR = 
desc "Sync doc/ with rubyforge site"
task :sync_rubyforge do |rf|
    rf_config = YAML::load(File.read(File.join(ENV["HOME"],".rubyforge","user-config.yml")))
    dest_host = "#{rf_config['username']}@rubyforge.org"
    dest_dir  = "/var/www/gforge-projects/#{SPEC.rubyforge_project}/#{SPEC.name}"

    # trailing slash on source, none on destination
    sh "rsync -zav --delete doc/ #{dest_host}:#{dest_dir}"
end

desc "Remove all content from the rubyforge site"
task :clean_rubyforge => [:clobber, :sync_rubyforge] 

desc "Push the published docs to rubyforge"
task :publish_rubyforge => [:publish_docs, :sync_rubyforge] 

#-----------------------------------------------------------------------
# Create an announcement text file, and post news to rubyforge
#-----------------------------------------------------------------------
require 'rubyforge'
def changes
    change_file = File.expand_path(File.join(File.basename(__FILE__),"..","CHANGES"))
    sections    = File.read(change_file).split(/^(?===)/)
end
def last_changeset
    changes[1]
end

def announcement
    urls    = "  #{SPEC.homepage}"
    subject = "#{SPEC.name} #{SPEC.version} Released"
    title   = "#{SPEC.name} version #{SPEC.version} has been released."
    body    = <<BODY
#{SPEC.description.rstrip}

{{ Changelog for Version #{SPEC.version} }}

#{last_changeset.rstrip}

BODY

    return subject, title, body, urls
end

desc "Create an email announcement file"
task :email do
    subject, title, body, urls = announcement

    File.open("email.txt", "w") do |mail|
        mail.puts "From: #{SPEC.author} <#{SPEC.email}>"
        mail.puts "To: ruby-talk@ruby-lang.org"
        mail.puts "Date: #{Time.now.rfc2822}"
        mail.puts "Subject: [ANN] #{subject}"
        mail.puts
        mail.puts title
        mail.puts
        mail.puts urls
        mail.puts 
        mail.puts body
        mail.puts 
        mail.puts urls
    end
    puts "Created the following as email.txt:"
    puts "-" * 72
    puts File.read("email.txt")
    puts "-" * 72
end
CLOBBER << "email.txt"

desc "Post news to your project on rubyforge"
task :post_news do
    subject, title, body, urls = announcement
    rf = RubyForge.new
    rf.login
    rf.post_news(SPEC.rubyforge_project, subject, "#{title}\n\n#{urls}\n\n#{body}")
    puts "Posted to rubyforge"
end

#-----------------------------------------------------------------------
# post the packaged files to rubyforge, again, a modified version of
# what ships with hoe.
#-----------------------------------------------------------------------
desc "Release files to rubyforge"
task :release_rubyforge => [:clean, :package] do 
    rf = RubyForge.new
    rf.login

    config = rf.userconfig
    config["release_notes"]     = SPEC.description
    config["release_changes"]   = last_changeset
    config["Prefomatted"]       = true

    files = FileList["pkg/#{SPEC.name}-#{SPEC.version}.*"].to_a
    puts "Uploading to rubyforge..."
    rf.add_release(SPEC.rubyforge_project, SPEC.name, SPEC.version, *files)
    puts "done."
end

