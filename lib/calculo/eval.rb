require_relative 'interpreter'

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
                                result = results.pop.reduce(op_stack.pop)

                        elsif type == 'reverse' or type == 'reverse-lisp'
                                result = results.pop.reverse.reduce(op_stack.pop)
                        end

                        if depth > 0
                                depth -= 1
                                results[depth].push(result)
=begin
                        elsif depth == 0
                                return result
                        end
=end

                elsif category == :Operator
                        op_stack.push(item)

                elsif category == :Number
                        results[depth].push(item)
                end
        }
        return result
end

def calculi_eval(assoc_array,type)
        case type
        when 'lisp' || 'reverse-lisp' || 'reverse'
                parse_tree = lisp_parse(assoc_array)
                eval_lisp(parse_tree,type)
        when 'infix'
                parse_tree = rpn_parse(shunting_yard(assoc_array))
                eval_rpn(parse_tree)
        when 'rpn' || 'postfix'
                parse_tree = rpn_parse(assoc_array)
                eval_rpn(parse_tree)
        when 'pn' || 'prefix'
                parse_tree = pn_parse(assoc_array)
                eval_pn(parse_tree)
        end
end
