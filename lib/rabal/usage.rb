require 'rabal'

module Rabal

    # Rabal has unique Usage output requirements and as such the default
    # usage provided by the Main gem although nice are not sufficient.
    # 
    # Rabal requires the Usage to be generated after the parameters have
    # been parsed as the parameters that are on the commandline
    # determine how the help is printed.
    class Usage

        attr_reader :app

        def initialize(app)
            @app = app
        end

        # some of the generated usage is quite useful, others we want
        # to dump, or rename
        def to_s
            u = ::Main::Usage.new

            u['name']        = "#{app.main.name} v#{app.main.version}"
            u['synopsis']    = app.main.synopsis
            u['description'] = ::Main::Util.columnize(app.main.description, :indent => 6, :width => 78)

            arguments       = app.main.parameters.select{|p| p.type == :argument}
            global_options  = app.main.parameters.select{|p| p.type == :option and app.global_option_names.include?(p.name) }
            load_options    = app.main.parameters.select{|p| p.type == :option and app.plugin_load_option_names.include?(p.name) }
            plugin_options  = app.main.parameters.select{|p| p.type == :option and app.plugin_option_names.include?(p.name) }

            # rework the formatting of the parameters limiting them to
            # the globals, force 
            u['global options'] = section_options("  ",global_options)

            # format the available modules
            s = ""
            s << ::Main::Util.columnize("Force any module to be used by giving the --use-[modulename] option.  Modules with a '*' next to them are always used.",:indent => 0, :width => 72)
            s << "\n\n"
            s << ""
            module_options = []
            app.plugin_manager.plugins.sort_by{|c,p| c}.each do |cat,plugins|
                 plugins.each do |key,plugin|
                     pre = "  " + (plugin.use_always? ? "*" : " ")
                     s << option_format(pre,"#{plugin.use_name} (#{plugin.register_path})",plugin.description,40,43,78)
                     s << "\n"

                     # create the module options for this one, if the
                     # plugin is use_always.
                     if app.main.parameters['use-all'].given? or plugin.use_always? or 
                         app.main.parameters["use-#{plugin.use_name}"].given? then
                        plugin_options = app.main.parameters.select{|p| p.type == :option and p.name =~ %r{^#{plugin.use_name}}}
                        module_options << ["Module options - #{plugin.use_name.camelize}", section_options("  ",plugin_options)]
                     end
                 end
            end


            u['Available Modules'] = s
       
            module_options.each { |k,v| u[k] = v }


            u['author'] = app.main.author
            # fake out usage so that it allows no parameters
            u.main = OpenStruct.new( { :parameters => [] } )
            u.to_s
        end

        # take in an option and a description and some formatting
        # criteria and format a single option
        def option_format(pre,option,description,col1,col2,width)
            s = ""
            s << "#{pre}#{option}".ljust(col1)
            if description then
                lines = ::Main::Util.columnize(description,:indent => col2, :width => width).split("\n")
                inter_first = ' ' * (col2 - col1 - 2) 
                s << lines.shift.sub(/^\s*/,"#{inter_first}- ")
                if lines.size > 0 then
                    s << "\n"
                    s << lines.join("\n")
                end
            end
            s
        end

        def section_options(pre,list)
            if list.size == 0 then
                return "No options available\n"
            end
            list.sort_by{|p| p.name}.collect do |p|
                ps = ""
                ps << option_format(pre,p.short_synopsis,p.description,42,45,78)
                ps
            end.join("\n")
        end
    end
end
