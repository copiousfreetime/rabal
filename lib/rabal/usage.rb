require 'main'
module Rabal

    # Rabal has unique Usage output requirements and as such the default
    # usage provided by the Main gem although nice are not sufficient.
    # 
    # Rabal requires the Usage to be generated after the parameters have
    # been parsed as the parameters that are on the commandline
    # determine how the help is printed.
    class Usage

        attr_reader :app
        attr_reader :old_usage

        def initialize(app)
            @app = app
            @old_usage = {}
            app.main.usage.each_pair do |key,value|
                @old_usage[key] = value
            end
        end

        # some of the generated usage is quite useful, others we want
        # to dump, or rename
        def to_s
            u = ::Main::Usage.new
            # just transfer directly over these
            %w[name synopsis description].each do |chunk|
                u[chunk.dup] = old_usage[chunk].to_s
            end

            arguments       = app.main.parameters.select{|p| p.type == :argument}
            global_options  = app.main.parameters.select{|p| p.type == :option and app.global_option_names.include?(p.name) }
            load_options    = app.main.parameters.select{|p| p.type == :option and app.plugin_load_option_names.include?(p.name) }
            plugin_options  = app.main.parameters.select{|p| p.type == :option and app.plugin_option_names.include?(p.name) }

            # rework the formatting of the parameters limiting them to
            # the globals, force 
            u['global options'] = section_options(global_options)

            # format the available modules
            u['Available Modules'] = section_options(load_options)
        
            load_options.each do |lo|
                if app.main.parameters['use-all'].given? or lo.given?  then
                    parts = lo.name.split('-')
                    parts.shift
                    plugin_name = parts.join('-')
                    plugin_options = app.main.parameters.select{|p| p.type == :option and p.name =~ %r{^#{plugin_name}}}
                    u["Module options - #{plugin_name.camelize}"] = section_options(plugin_options)
                end
            end

            u['author'] = old_usage['author']
            u.to_s
        end

        def section_options(list)
            list.collect do |p|
                ps = ""
                ps << ::Main::Util.columnize("  * #{ p.synopsis }", :indent => 2, :width => 78)
                ps << "\n" 
                if p.description? then
                    ps << ::Main::Util.columnize(p.description, :indent => 7, :width => 78)
                    ps << "\n"
                end
                ps
            end.join("\n")
        end
    end
end
