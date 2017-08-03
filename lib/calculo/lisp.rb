require 'parse'
class Lisp
        attr_accessor :string
        attr_accessor :type
        attr_accessor :array
        attr_accessor :result

        def initialize(string, type)
                @string = string
                @type = type
                @array = parse(@string)
                @result = eval_lisp(@array)
        end

        @private
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

        def eval_lisp(array)
                length, l, r = innermost_pair(array)
                result = execute(array[l..r],type)

                if length > 2
                        # Inserts the result in between the portions
                        # of the array not including the portion just
                        # used to calculate the result
                        new_array = array[0..(l-1)] + [result] + array[(r+1)..-1]
                        eval_lisp(new_array)

                elsif length == 2
                        return result
                end
        end        
end
