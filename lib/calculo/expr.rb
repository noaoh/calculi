require_relative 'shunting_yard'
require 'pry'

class MathExpression
        attr_accessor :type
        attr_accessor :string
        attr_accessor :assoc_array
        attr_accessor :result

        def initialize(string,type)
                @string = string
                if type == 'infix'
                        @type = 'rpn'
                        @assoc_array = shunting_yard(lexer(parse(@string)))
                        @result = eval_rpn(@assoc_array)

                elsif type == 'lisp' or type == 'reverse-lisp' or type == 'reverse'
                        @type = type
                        @assoc_array = lexer(parse(@string))
                        @result = eval_lisp(@assoc_array,@type)

                else
                        @assoc_array = lexer(parse(@string))
                        @type = type
                        if @type == 'prefix' or @type == 'pn'
                                @result = eval_pn(@assoc_array)

                        elsif @type == 'postfix' or @type == 'rpn'
                                @result = eval_rpn(@assoc_array)
                        end
                end
        end

        @private
        def eval_pn(assoc_array)
                stack = []
                assoc_array.reverse.each{|category, item|
                        if category == :Operator
                                num2,num1 = stack.pop(2)
                                result = num1.method(item).call(num2)
                                stack.push(result)

                        elsif category == :Number
                                stack.push(item)
                        end
                        
                }
                return stack.pop
        end
                        
        def eval_rpn(assoc_array)
                stack = []
                assoc_array.each{|category, item|
                        if category == :Operator 
                                num1,num2 = stack.pop(2)
                                result = num1.method(item).call(num2)
                                stack.push(result)

                        elsif category == :Number
                                stack.push(item)
                        end
                }
                return stack.pop
        end

        #Lisp.rb stuff
        def eval_lisp(assoc_array,type)
                op_stack = []
                results = []
                depth = -1 
                assoc_array.each{|category, item|
                        if category == :LParen
                                depth += 1
                                results[depth] = []

                        elsif category == :RParen
                                if type == 'lisp' 
                                        result = results.pop.reduce(op_stack.pop.to_sym)

                                elsif type == 'reverse' or type == 'reverse-lisp'
                                        result = results.pop.reverse.reduce(op_stack.pop.to_sym)
                                end

                                if depth > 0
                                        depth -= 1
                                        results[depth].push(result)

                                elsif depth == 0
                                        return result
                                end

                        elsif category == :Operator
                                op_stack.push(item)

                        elsif category == :Number
                                results[depth].push(item)
                        end
                }

        end
end
