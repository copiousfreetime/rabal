module Rabal
    AUTHOR          = "Jeremy Hinegardner".freeze
    AUTHOR_EMAIL    = "jeremy@hinegadner.org".freeze
    HOMEPAGE        = "http://copiousfreetime.rubyforge.org/rabal/"
    COPYRIGHT       = "2007 #{AUTHOR}".freeze
    DESCRIPTION     = <<DESC
Rabal is a commandline application for bootstrapping, packaging and
distributing ruby projects.
DESC

    ROOT_DIR        = File.expand_path(File.join(File.dirname(__FILE__),".."))
    LIB_DIR         = File.join(ROOT_DIR,"lib").freeze
    DATA_DIR        = File.join(ROOT_DIR,"data").freeze
    TEMPLATE_DIRS   = [ File.join(DATA_DIR,"trees").freeze ]
    KNOWN_WORDS     = {
        "rabal.project" => lambda { |tree| tree.root.name }
    }

    class TemplateNotFoundError < StandardError ; end

    class Application
        class << self
            def run(main)

                root = DirectoryTree(main.params["directory"])
                project = ProjectTree.new(main.param["project"],"rabal:base")
                root << project
                main.params.each do |p|
                    puts "#{p.name} #{p.value} #{p.given? ? "given" : "not given"}"
                    md = %r{\Awith-(.*)\Z}.match(p.name)
                    if md and p.given? then
                        project << Tree.of_kind(md.captures.first).new(p.value)
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

            def find_src_directory(template_name)
                template_path = template_name.split(":").join(File::SEPARATOR)
                TEMPLATE_DIRS.each do |dir|
                    src_dir = File.join(dir,template_path)
                    return src_dir if File.directory?(src_dir)
                end
                raise TemplateNotFoundError, "'#{template_name}' was not found in any template directory"
            end
        end
    end
end

Dir.entries(File.join(Rabal::LIB_DIR,"rabal")).each do |rb|
    if rb =~ /\.rb\Z/ then
        f = File.basename(rb,".rb")
        require "rabal/#{f}"
    end
end
