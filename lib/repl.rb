require 'IO/console'
require 'os'

class Repl
        attr_accessor :history
        attr_accessor :prompt
        attr_accessor :type
        def initialize(prompt,type)
                @history = []
                @prompt = "[#{@history.length}]" + prompt + " "
                @type = type
                clear_screen()
                calculi_loop(@prompt)
        end

        def clear_screen
                if OS.linux? or OS.mac? or OS.bsd?
                        system('clear')
                elsif OS.windows?
                        system('cls')
                end
        end

        def calculi_print(history)
                history.each_with_index.map{|x,i| puts("#{i} : #{x}\n")}
        end

        def repl_eval(input)
                # syntax for changing prompt/type is:
                # set prompt/type = 'foo'
                # or set prompt/type 'foo'
                if input.start_with?("set","change")
                        @history.push(input)
                        input_array = input.split(' ')

                        if input_array[1] == "prompt" and input_array.last != "prompt"
                                prompt = input_array.last
                                return puts("prompt now is #{@prompt}")

                        elsif input_array[1] == "type" and input_array.last != "type"
                                @type = input_array.last        
                                return puts("type now is #{@type}")
                        else
                                puts "Error: variable can not be changed"
                        end

                # If input is simply history, print all of the history
                # can also use ruby range syntax, STARTING AT 0
                # for example: history 0..-2 will print all but the
                # last entry of history 
                elsif input.start_with?("history")
                        @history.push(input)
                        if input == "history"
                                return calculi_print(@history)
                        else
                                input_array = input.split(' ')
                                input_range = input_array[-1]
                                if input_range.length == 1
                                        return puts(@history[input_range.to_i])
                                elsif input_range.length == 4
                                        return calculi_print(@history[(input_range.chars.first.to_i)..(input_range.chars.last.to_i)])
                                elsif input_range.length == 5
                                        return calculi_print(@history[(input_range.chars.first.to_i)..(input_range.chars.drop(2).to_i)])
                                end
                        end

                elsif input.start_with?("clear")
                        @history.push(input)
                        if input == "clear"
                                return clear_screen()
                        elsif input == "clear history"
                                @history = []
                                return puts("History is now blank")
                        end

                else 
                        if @type == 'lisp' or @type == 'reverse-lisp' or @type == 'reverse'
                               output = puts("#{Lisp.new(input,@type).string} : #{Lisp.new(input,@type).result}")
                        elsif @type == 'postfix' or @type == 'infix' or @type == 'prefix' or @type == 'pn' or @type == 'rpn'
                               output = puts("#{MathNotation.new(input,@type).string} : #{MathNotation.new(input,@type).result}")
                       @history.push(output)
                       return output
                       end
                end
        end

        def calculi_prompt(default,*args)
                print(*args)
                result = gets.strip
                if result.empty?
                        return default
                else
                        return repl_eval(result)
                end
        end

        def calculi_loop(prompt,input="Welcome to calculi!")
                puts input
                until input == "exit" or input == 'quit' or STDIN.getch == "\u0003"
                        input = calculi_prompt('No input found',prompt)
                end
                puts "Exiting calculi"
                exit(1)
        end
end