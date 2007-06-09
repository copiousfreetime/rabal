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
            global_options  = app.main.parameters.select{|p| p.type == :option and (p.name == "use-all" or p.name !~ /^use/) }
            load_options    = app.main.parameters.select{|p| p.type == :option and (p.name != "use-all" and p.name =~ /^use/) }

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
                    plugin_main = app.plugins_main[plugin_name]
                    #plugin_options = app.plugins_main[plugin_name].parameters
                    puts "plugin_main => #{plugin_main.object_id}"
                    u["Plugin Options - #{plugin_name}"] = section_options(plugin_options)
                    #app.plugins_main.each_pair do |key,main|
                        #puts "key => #{key}, plugin_name => #{plugin_name}"
                        #plugin_options = app
                        #puts main.usage
                    #app.plugins_main[plugin_name].parameters.each do |p|
                        #puts p.synopsis
                    #end
                    #u["#{plugin_name.camelize} Options"] = section_options(app.plugins_main[plugin_name])
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
