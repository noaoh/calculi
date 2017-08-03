def shunting_yard(infix_array)
        operators = {'+' => 2, '-' => 2, '*' => 3, '/' => 3, '>' => 4, '<' => 4, '=' => 4, '%' => 4, '**' => 4}
        rpn_expr = []
        op_stack = []

        infix_array.each do |item|
                if operators.has_key?(item)
                        op2 = op_stack.last
                        if operators.has_key?(op2) and ((op2 == "**" and operators[item] < operators[op2]) or (op2 != "**" and operators[item] <= operators[op2]))
                                rpn_expr.push(op_stack.pop)
                        end
                        op_stack.push(item)

                elsif item == "("
                        op_stack.push(item)

                elsif item == ")"
                        until op_stack.last == "("
                                rpn_expr.push(op_stack.pop)
                        end
                        op_stack.pop
                else
                        rpn_expr.push(item)
                end
        end

        until op_stack.empty?
                rpn_expr.push(op_stack.pop)
        end

        return rpn_expr
end
