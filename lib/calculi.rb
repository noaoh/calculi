require 'optparse'
require 'pry'
require_relative 'shunting_yard'

def parse(string)
        # First regex puts a space after a parenthesis/math operation,
        # Second regex a space between a digit and a parenthesis/math
        # operation(s)
        # Third regex converts any double spaces into single space
        # Fourth regex converts to the exponent operator used in ruby
        # split seperates the characters based on a space
        #

        op_re = Regexp.new(/([^\d\w\s\-])/)
        dig_op_re = Regexp.new(/\d[^\d\w\s]+/)
        dbl_space_re = Regexp.new(/\s{2,}/)
        exp_re = Regexp.new(/\^/)
        dig_re = Regexp.new(/\d+/)
        array = string.gsub(op_re,'\1 ').gsub(dig_op_re){ |s| s.chars.join(' ')}.gsub(dbl_space_re,' ').gsub(exp_re,'**').split(' ')

        # Regex finds if array element matches a digit, and converts it
        # to a float.
        array = array.map{|x| dig_re.match(x) != nil ? x.to_f : x}
        return array
end

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

type = "lisp"
string = "( - ( + ( / 18 ( ^ 3 2 ) ) 12 ) 13 )"
@Lisp = Lisp.new(string,type)

type = "reverse-lisp"
string = "( 13 ( 12 ( ( 2 3 ^ ) 18 / ) + ) - )"
@ReverseLisp = Lisp.new(string,type)

type = "pn"
string = "- + / 18 ^ 3 2 12 13"
@PN = MathNotation.new(string,type)

type = "rpn"
string = "12 18 3 2 ^ / 13 - +"
@RPN = MathNotation.new(string,type)

type = "infix"
string = "12 + 18 / ( 3 ^ 2 ) - 13"
@Infix = MathNotation.new(string,type)
