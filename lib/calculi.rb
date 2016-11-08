$symbol_table = {'numbers' => [1,2,3,4,5,6,7,8,9], 'operators' => ['+', '-', '*', '/', '^', '%', '>', '<']}
$infix_operator_precendence = {'+' => 2, '-' => 2, '*' => 3, '/' => 3, '^' => 4, '(' => 5, ')' => 5}

class Calculi
        def initialize(string, type)
                @string = string
                @type = type
        end

        def parse
                case @type
                when 'pn' || 'rpn'
                        @array = math_notation_parse(@string)
                when 'lisp' || 'reverse_lisp'
                        @array = lisp_parse(@string)
                end
        end

        def indices_finder
                case @type
                when 'pn' || 'rpn'
                       @indices = math_notation_indices_finder(array, type)
                when 'lisp' || 'reverse-lisp'                 
                       @indices = lisp_indices_finder(array)
                end
        end
        
        def eval
                case @type
                when 'pn' || 'rpn'
                        math_notation_eval(@array, @type, @indices)
                when 'lisp' || 'reverse-lisp'
                        lisp_eval(@array, @type, @indices)
                end
        end
end

class String
        def is_numeric?(s)
                begin
                        Float(s)
                rescue
                        false
                else 
                        true
                end
        end
end

class Lisp
        def initialize(string, type)
                @string = string
                @type = type
        end

        def parse
                @array = @string.split(' ')
                @array = @array.map{|x| is_numeric?(x) == false && x.length > 1 ? x.split('') : x}.flatten
                @array = @array.map{|x| is_numeric?(x) != false ? x.to_f : x}
        end

        def indices_finder
                @indices = array.length.times.select{|i| array[i] == "(" || array[i] == ")"}
        end

        def eval
                @parenthesis_pairs = []
                while @indices.length > 0
                        @parenthesis_pairs.unshift(@indices.shift, @indices.pop)
                end
                @parenthesis_pairs.map{|l, r| @array.insert(l, eval_subarray_executor(@array.slice!(@array[l..r])))}
        end        
end

class Math-Notation 
        def initialize(string, type)
                @string = string
                @type = type
                @num_elements = {"pn" => 3, "rpn" => -3}
        end

        def parse
                @array = @string.split(' ')
                @array = @array.map{|x| is_numeric?(x) != false ? x.to_f : x}
        end

        def indices_finder
                @indices = @array.length.times.select{|i| $symbol_table['operators'].include?(@array[i])}.reverse 
        end

        def eval
                @indices.map{|i| @array.insert(i, eval_subarray_executor(@array.slice!(i, num_elements[type]), type))}
                return @array[0]
        end
end


def eval_subarray_executor(array, type)
        case type
        when 'pn'
                eval_pn_array(*array)
        when 'rpn'
                eval_rpn_array(*array)
        when 'infix'
                eval_infix_array(*array)
        when 'lisp'
                eval_lisp_array(*array)
        when 'reverse-lisp'
                eval_reverse_lisp_array(*array)
        end
end

def eval_pn_array(operator, num1, num2)
        num1.method(operator).call(num2)
end

def eval_rpn_array(num1, num2, operator)
        num2.method(operator).call(num1)
end

def eval_infix_array(num1, operator, num2)
        num1.method(operator).call(num2)
end

def eval_lisp_array(array)
        array[2..-2].reduce(array[1].to_sym)
end

def eval_reverse_lisp_array(array)
        array[1..-3].reduce(array[-2].to_sym)
end
