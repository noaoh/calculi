require 'parse'
require 'shunting_yard'

class MathExpression
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

                elsif type == 'lisp' or type == 'reverse-lisp' or type == 'reverse'
                        @type = type
                        @array = parse(@string)
                        @result = eval_lisp(@array)

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
                stack = []
                array.reverse.each{|item|
                        if item.first == :Operator
                                num2,num1 = stack.pop(2)
                                result = num1.method(item).call(num2)
                                stack.push(result)

                        elsif item.first == :Number
                                stack.push(item)
                        end
                }
                return stack.pop
        end
        
        def recur_eval_pn(array,reverse_array=array.reverse,stack=[])
                if reverse_array.first.first == :Operator
                        num2,num1 = stack[-2..-1]
                        op = reverse_array.first.last
                        result = num1.method(op).num2
                        new_array = reverse_array.drop(1)
                        new_stack = stack[0..-3].push(result)
                        recur_eval_rpn(array,new_array,new_stack)

                elsif reverse_array.first.first == :Number
                        new_array = reverse_array.drop(1)
                        recur_eval_rpn(array,new_array,new_stack.push(reverse_array.first.last))
                
                elsif reverse_array.empty?
                        return stack[0]
                end
        end

        def eval_rpn(array)
                stack = []
                array.each{|item|
                        if item.first == :Operator 
                                num1,num2 = stack.pop(2)
                                result = num1.method(item).call(num2)
                                stack.push(result)

                        elsif item.first == :Number
                                stack.push(item)
                        end
                }
                return stack.pop
        end

        def recur_eval_rpn(array,stack=[])
                if array.first.first == :Operator
                        num1,num2 = stack[-2..-1]
                        op = array.first.last.to_sym
                        result = num1.method(op).num2
                        new_array = array.drop(1)
                        new_stack = stack[0..-3].push(result)
                        recur_eval_rpn(new_array,new_stack)

                elsif array.first.first == :Number
                        new_array = array.drop(1)
                        recur_eval_rpn(new_array,stack.push(array.first.last))
                
                elsif array.empty?
                        return stack[0]
                end
        end

        #Lisp.rb stuff
        def execute(array,type)
                case type
                when 'lisp'
                        array[2..-2].reduce(array[1].to_sym)
                when 'reverse-lisp' || 'reverse'
                        array[1..-3].reverse.reduce(array[-2].to_sym)
                end
        end

        def innermost_pair(array)
                l_parens = []
                r_parens = []

                array.each_with_index do |item, index|

                        if item == "("
                                l_parens.push(index)

                        elsif item == ")"
                                r_parens.push(index)
                        end
                end

                total_length = l_parens.length + r_parens.length
                return [total_length, l_parens[-1], r_parens[0]]
        end

        def eval_lisp(array,type)
                length, l, r = innermost_pair(array)
                array_slice == array[l..r]
                result = execute(array_slice,type)

                if length > 2
                        # Inserts the result in between the portions
                        # of the array not including the portion just
                        # used to calculate the result
                        new_array = array[0..(l-1)] + [result] + array[(r+1)..-1]
                        eval_lisp(new_array,type)

                elsif length == 2
                        return result
                end
        end        

end
