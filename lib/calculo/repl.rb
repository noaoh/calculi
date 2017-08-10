require 'parse'
require 'IO/console'
require 'os'
require 'pry'

class Repl
        attr_accessor :history
        attr_accessor :prompt
        attr_accessor :type
        def initialize(prompt,type)
                @history = []
                @vars = {}
                @stack = []
                @og_prompt = prompt
                @prompt = "[#{@history.length}]" + @og_prompt + " "
                @type = type
                clear_screen()
                calculo_loop()
        end

        def clear_screen
                if OS.linux? or OS.mac? or OS.bsd?
                        system('clear')
                elsif OS.windows?
                        system('cls')
                end
        end

        def calculo_print(history)
                history.each_with_index.map{|x,i| puts("#{i} : #{x}\n")}
        end

        def repl_eval(input)
                # syntax for changing prompt/type is:
                # set prompt/type = foo
                # or set prompt/type foo
                if input.start_with?("set","change")
                        @history.push(input)
                        input_array = input.split(' ')

                        if input_array[1] == "prompt" and input_array.last != "prompt"
                                @og_prompt = input_array.last
                                @prompt = "[#{@history.length}]" + @og_prompt + " "
                                return "prompt is now #{@prompt}"

                        elsif input_array[1] == "type" and input_array.last != "type"
                                @type = input_array.last        
                                return "type is now #{@type}"
                        else
                                return "Error: variable can not be changed"
                        end

                # If input is simply history, print all of the history
                # can also use ruby range syntax, STARTING AT 0
                # for example: history 0..-2 will print all but the
                # last entry of history 
                elsif input.start_with?("history")
                        @history.push(input)
                        if input == "history"
                                return calculo_print(@history)
                        else
                                input_array = input.split(' ')
                                input_range = input_array[-1]
                                if input_range.length == 1
                                        return @history[input_range.to_i]
                                elsif input_range.length == 4
                                        return calculo_print(@history[(input_range.chars.first.to_i)..(input_range.chars.last.to_i)])
                                elsif input_range.length == 5
                                        return calculo_print(@history[(input_range.chars.first.to_i)..(input_range.chars.drop(2).to_i)])
                                end
                        end

                elsif input.start_with?("clear")
                        @history.push(input)
                        if input == "clear"
                                return clear_screen()
                        elsif input == "clear history"
                                @history = []
                                return "History is now blank"
                        end

                elsif input == "exit" or input == "quit"
                        return "Exiting calculo!"

                else 
                        if @type == 'lisp' or @type == 'reverse-lisp' or @type == 'reverse'
                               repl_class = Lisp.new(input,@type)
                               calculo_output = "#{repl_class.string} : #{repl_class.result}"
                               @history.push(calculo_output)
                               @stack.push(repl_class.result)
                               return calculo_output
                                       
                        elsif @type == 'postfix' or @type == 'infix' or @type == 'prefix' or @type == 'pn' or @type == 'rpn'
                               repl_class = MathNotation.new(input,@type)
                               calculo_output = "#{repl_class.string} : #{repl_class.result}"
                               @history.push(calculo_output)
                               @stack.push(repl_class.result)
                               return calculo_output
                       end
                end
        end

        def calculo_loop(output="Welcome to calculo!")
                input = nil
                while output != "Exiting calculo!"
                        puts(output)
                        @prompt = "[#{@history.length}]" + @og_prompt + " "
                        print(@prompt)
                        input = gets.chomp
                        output = repl_eval(input)
                end
                puts(output)
                exit(1)
        end
end
