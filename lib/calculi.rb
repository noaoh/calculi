require 'optparse'
require_relative 'lisp'
require_relative 'math'
require_relative 'repl'

options = {}
OptionParser.new do |opts|
        opts.banner = "Usage: calculi.rb [options]"
        opts.on("-t","--type TYPE",String,"The type of expression to be computed") do |type|
                options[:type] = type
        end

        opts.on("-e","--expr EXPR",String,"The expression to be computed") do |expr|
                options[:expr] = expr
        end
        opts.on("-f","--file FILE",String,"Reads expressions from a file") do |file|
                options[:file] = file
        end
        opts.on("-h","--help","Prints this help") do
                puts opts
        end
end.parse!

def cli_eval(string,type)
        case type
        when 'lisp' || 'reverse-lisp' || 'reverse'
                cli = Lisp.new(string,type)
                return "#{cli.string} = #{cli.result}"
        when 'rpn' || 'postfix' || 'pn' || 'prefix' || 'infix'
                cli = MathNotation.new(string,type)
                return "#{cli.string} = #{cli.result}"
        end
end

if not options.empty?
        if options.has_key?(:file)
                File.open(options[:file]).each_line do |line|
                        puts(cli_eval(line,options[:type]))
                end
        elsif options.has_key?(:expr)
                puts(cli_eval(options[:expr],options[:type]))
        elsif options.has_key?(:type)
                Repl.new("=>",options[:type])
        end
else
        Repl.new("=>","infix")
end
