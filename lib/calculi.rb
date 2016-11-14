class Calculi
        def initialize(string, type)
                @string = string
                @type = type
        end

        def parse
                case @type
                when 'pn' || 'rpn'
                        @array = MathNotation.new(@string, @type).parse
                when 'lisp' || 'reverse_lisp'
                        @array = Lisp.new(@string, @type).parse
                end
        end

        def indices_finder
                case @type
                when 'pn' || 'rpn'
                        @indices = MathNotation.new(@array, @type).indices_finder
                when 'lisp' || 'reverse-lisp'                 
                        @indices = Lisp.new(@array, @type).indices_finder
                end
        end

        def eval
                case @type
                when 'pn' || 'rpn'
                        MathNotation.new(@string, @type).eval
                when 'lisp' || 'reverse-lisp'
                        Lisp.new(@string, @type).eval
                end
        end
end

class String
        def is_numeric?
                begin
                        Float(self)
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
                @array = @array.map{|x| x.is_numeric? == false && x.length > 1 ? x.split('') : x}.flatten
                @array = @array.map{|x| x.is_numeric? != false ? x.to_f : x}
        end

        def execute_lisp_array(array)
                array[2..-2].reduce(array[1].to_sym)
        end

        def execute_reverse_lisp_array(array)
                array[0..-2].reduce(array[-1].to_sym)
        end

        def execute(array)
                case @type
                when 'lisp'
                        execute_lisp_array(array)
                when 'reverse-lisp'
                        execute_reverse_lisp_array(array)
                end
        end

        def indices_finder
                self.parse
                @indices = @array.length.times.select{|i| @array[i] == "(" || @array[i] == ")"}
                @parenthesis_pairs = []
                while @indices.length > 0
                        @parenthesis_pairs.unshift([@indices.shift, @indices.pop])
                return @parenthesis_pairs
                end
        end

        def eval
                self.indices_finder
                case @type
                        when 'lisp'
                                @parenthesis_pairs.map{|l, r| @array.insert(l, execute(@array.slice!(l..r)))}
                        when 'reverse-lisp'
                                @parenthesis_pairs.map{|l, r| @array.insert(r, execute(@array.slice!(l..r)))}
                        end
                return @array[0]
        end        
end

class MathNotation 
        def initialize(string, type)
                @string = string
                @type = type
                @num_elements = {"pn" => 3, "rpn" => -3}
                @symbol_table = {'numbers' => [1,2,3,4,5,6,7,8,9], 'operators' => ['+', '-', '*', '/', '^', '%', '>', '<']}
                @infix_operator_precendence = {'+' => 2, '-' => 2, '*' => 3, '/' => 3, '^' => 4, '(' => 5, ')' => 5}
        end

        def parse
                @array = @string.split(' ')
                @array = @array.map{|x| x.is_numeric? != false ? x.to_f : x}
        end

        def execute(array)
                case @type
                when 'pn'
                        execute_pn_array(*array)
                when 'rpn' 
                        execute_rpn_array(*array)
                when 'infix'
                        execute_infix_array(*array)
                end
        end 

        def execute_pn_array(operator, num1, num2)
                num1.method(operator).call(num2)
        end

        def execute_rpn_array(num2, num1, operator)
                num2.method(operator).call(num1)
        end

        def execute_infix_array(num1, operator, num2)
                num1.method(operator).call(num2)
        end                

        def indices_finder
                @indices = @array.length.times.select{|i| @symbol_table['operators'].include?(@array[i])}.reverse 
        end

        def eval
                self.parse
                self.indices_finder
                @indices.map{|i| @array.insert(i, execute(@array.slice!(i, @num_elements[@type])))}
                return @array[0]
        end
end

class REPL
        def initialize(prompt)
                @prompt = prompt
        end
end
