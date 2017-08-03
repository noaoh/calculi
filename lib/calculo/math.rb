require 'parse'
require 'shunting_yard'
class MathNotation
        attr_accessor :type
        attr_accessor :string
        attr_accessor :array
        attr_accessor :result

        def initialize(string,type)
                @string = string
                if type == 'infix'
                        @type = 'rpn'
                        @array = shunting_yard(parse(@string))
                        @result = eval_rpn(@array)
                else
                        @array = parse(@string)
                        @type = type
                        if @type == 'prefix' or @type == 'pn'
                                @result = eval_pn(@array)
                        elsif @type == 'postfix' or @type == 'rpn'
                                @result = eval_rpn(@array)
                        end
                end
        end

        @private
        def eval_pn(array)
                operators = ['+','-','^','%','/','**','*']
                stack = []
                array.reverse.each{|item|
                        if operators.include?(item)
                                num2,num1 = stack.pop(2)
                                result = num1.method(item).call(num2)
                                stack.push(result)
                        else
                                stack.push(item)
                        end
                }
                return stack.pop
        end

        def eval_rpn(array)
                operators = ['+','-','^','%','/','**','*']
                stack = []
                array.each{|item|
                        if operators.include?(item)
                                num1,num2 = stack.pop(2)
                                result = num1.method(item).call(num2)
                                stack.push(result)
                        else
                                stack.push(item)
                        end
                }
                return stack.pop
        end
end
