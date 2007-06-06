require 'optparse'
#require 'active_support'

module Rabal
    class PluginX

        class << self

            # ==================
            # = DETECT PLUGINS =
            # ==================

            def inherited(base)
                plugins << base
            end

            def plugins
                @plugins ||= []
            end

            # ===================
            # = OPTION HANDLING =
            # ===================

            def load_option
      "--with-#{name.underscore.dasherize}"
            end

            def extend_options(opts)
                # Abstract, override in plugins
            end

        end

    end

    class Deployment < PluginX

        class << self

            def extend_options(opts)
                opts.on('--stages STAGES', '-s STAGES', Array, "Supported stages separated by commas") do |stages|
                    p stages
                end
            end

        end

    end
end

__END__
OptionParser.new do |opts|

    opts.banner =<<BANNER
Usage: rabal [OPTIONS]

OPTIONS
BANNER

    Plu.plugins.each do |plugin|
        opts.on(plugin.load_option, "Load #{plugin.name.titleize} plugin") do
            plugin.extend_options opts
        end  
    end

    opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
    end

end.parse!(ARGV)
