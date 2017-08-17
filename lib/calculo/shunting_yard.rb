require_relative 'parse'
require 'pry'

def shunting_yard(assoc_infix_array)
        rpn_expr = []
        op_stack = []

        assoc_infix_array.each{|category, item|
                if category == :Operator
                        unless op_stack.empty?
                                op2 = op_stack.last.last
                                if Operators.has_key?(op2) and Operators[item].op_lt(Operators[op2])
                                        rpn_expr.push(op_stack.pop)
                                end
                        end
                        op_stack.push([category, item])

                elsif category == :LParen
                        op_stack.push([category, item])

                elsif category == :RParen
                        until op_stack.last.last == "("
                                rpn_expr.push(op_stack.pop)

                        end
                        op_stack.pop



                elsif category == :Number
                        rpn_expr.push([category, item])
                end
        } 

        until op_stack.empty?
                rpn_expr.push(op_stack.pop)
        end

        return rpn_expr
end
