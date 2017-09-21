require 'pry'

Operator = Struct.new(:precedence, :associativity, :arity, :english, :ruby_operator, :function)

class Operator
        def left_associative?
                associativity == :left
        end

        #the < for operators
        def op_lt(other)
                if left_associative?
                        precedence <= other.precedence
                else
                        precedence < other.precedence
                end
        end
end

Operators = {
        :re_list => ["+","*","/","%","<",">","^","==","(",")","abs","ceil","floor"],
        "+" => Operator.new(2, :left, 2, "ADD", "+", -> (x,y) {x + y}),
        "-" => Operator.new(2, :left, 2, "SUB", "-", -> (x,y) {x - y}),
        "*" => Operator.new(3, :left, 2, "MUL", "*", -> (x,y) {x * y}),
        "/" => Operator.new(3, :left, 2, "DIV", "/", -> (x,y) {x / y}),
        "%" => Operator.new(3, :left, 2, "MOD", "%", -> (x,y) {x % y}),
        "<" => Operator.new(4, :left, 2, "LT", "<"), -> (x,y) {x < y}),
        ">" => Operator.new(4, :left, 2, "GT", ">"), -> (x,y) {x > y}),
        "**" => Operator.new(4, :right, 2, "EXP", "**", -> (x,y) {x ** y}),
        "==" => Operator.new(4, :none, 2, "EQ?", "==", -> (x,y) {x == y}),
        "abs" => Operator.new(4, :none, 1, "ABS", "abs", -> (x) {x.abs}),
        "ceil" => Operator.new(4, :none, 1, "CEIL", "ceil", -> (x) {x.ceil}),
        "floor" => Operator.new(4, :none, 1, "FLR", "floor", -> (x) {x.floor})
}

Command = Struct.new(:type, :arity, :desc, :english)

Commands = {
        "p" => Command.new(:stack,"p (NUM)","Print top num values from stack, without changing stack","PRINT"),
        "n" => Command.new(:stack,"n (NUM)","Print top num values from stack, and changes stack", "PRINTPOP"),
        "P" => Command.new(:stack,"P (NUM)","Pops top num off stack, without printing them", "POP"),
        "f" => Command.new(:stack,"f (NUM)","Prints entire contents of stack w/o altering anything","PRINTALL"),
        "c" => Command.new(:stack,"c","Clears the stack","CLEAR"),
        "r" => Command.new(:stack,"r","Swaps the order of the top two values on the stack","SWAP"),
        ";" => Command.new(:repl,";","Represents a new line, allows for multiple statements on same line","NEWLINE"),
        "set" => Command.new(:repl,"set (type,prompt) foo","Sets the type or prompt","SET"),
        "history" => Command.new(:repl,"history (start..end)","Prints the entire history of commands, unless a range is given","HISTORY"),
        "clear" => Command.new(:repl,"clear (history)","Clears the screen or the history","CLEAR"),
        "exit" => Command.new(:repl,"exit","Exit Calculi","EXIT"),
        "quit" => Command.new(:repl,"quit","Quit Calculi","QUIT"),
        "help" => Command.new(:repl,"help (command)","Displays help for the program or the command","HELP"),
        "tutorial" => Command.new(:repl,"tutorial","Runs a brief tutorial showcasing this program's features","TUTORIAL"),
        "=" => Command.new(:var,"variable = NUM","Creates a variable with value NUM","VAR"),
        "+=" => Command.new(:var,"variable += NUM","Adds the NUM to a variable","VARADD"),
        "-=" => Command.new(:var,"variable -= NUM","Subtracts the NUM from the variable","VARSUB"),
        "*=" => Command.new(:var,"variable *= NUM","Multiplies the variable by the NUM","VARMUL"),
        "/=" => Command.new(:var,"variable /= NUM","Divides the variable by the NUM","VARDIV"),
        "^=" => Command.new(:var,"variable ^= NUM","Raises the variable to the NUM power","VARPOW"),
        "%=" => Command.new(:var,"variable %= NUM","Modulos the variable by the NUM","VARMOD")
}

def tokenize(string)
        # First regex puts a space after a parenthesis/math operation,
        # Second regex a space between a digit and a parenthesis/math
        # operation(s)
        # Third regex converts any double spaces into single space
        # Fourth regex converts to the exponent operator used in ruby
        # split seperates the characters based on a space

        op_str = '('
        Operators[:re_list].each{|operator|
                if /[a-z]+/.match(operator)
                        op_str += "#{operator}|"
                else
                        op_str += "\\#{operator}|"
                end
        }

        op_str = op_str[0..-2] + ')'
        op_re = Regexp.new(op_str)
        dig_str = '\d'
        dig_op_str = dig_str + op_str + '+'
        dig_op_re = Regexp.new(dig_op_str)

        array = string.gsub(op_re,'\1 ')
        array = array.gsub(dig_op_re){|s| s.chars.join(' ')}
        array = array.gsub('  ',' ')
        array = array.gsub('^','**')
        array = array.gsub('==', 'eql?')
        array = array.split(' ')

        return array
end

def lexer(array)
        assoc_array = [] 
        array.each{|elem|
                if elem == '(' 
                        assoc_array.push([:LParen,elem])

                elsif elem == ')'
                        assoc_array.push([:RParen,elem])

                elsif Operators.has_key?(elem)
                        new_elem = elem.to_sym
                        assoc_array.push([:Operator,new_elem])

                elsif Commands.has_key?(elem)
                        new_elem = elem.to_sym
                        assoc_array.push([:Command,new_elem])

                elsif /\d+/.match(elem)
                        new_elem = elem.to_f % 1 == 0 ? elem.to_i : elem.to_f
                        assoc_array.push([:Number,new_elem])

                else
                        assoc_array.push([nil,elem])
                end
        }
        return assoc_array
end
#begin is a example parse for a lisp expression, it is 'assembled' below
lisp_string = "( * 12 12 ( - 4 ( * .75 2 ) 1.5 ) ( * 1 2 ( - 3 ( + 4 1 ) ) ) ( * 4 5 ) )"
# fucks up at 1.5
lisp_array = lexer(tokenize(lisp_string))
lisp_parse_tree = [[:Operator, :*], [:Number, 12], [:Number, 12], [[:Operator, :-], [:Number, 4], [[:Operator, :*] ,[:Number, 0.75] ,[:Number, 2]], [:Number, 1.5]], [[:Operator, :*], [:Number, 1], [:Number, 2], [[:Operator, :-], [:Number, 3], [[:Operator, :+], [:Number, 4], [:Number, 1]]]], [[:Operator, :*], [:Number, 4], [:Number, 5]]]

# http://thingsaaronmade.com/blog/writing-an-s-expression-parser-in-ruby.html 
def lisp_parse(assoc_array, offset = 0)
       parse_tree = []
       while offset < assoc_array.length
               if assoc_array[offset][0] == :LParen
                       # Multiple assignment from the array that lisp_parse()
                       # returns
                       offset, tmp_array = lisp_parse(assoc_array, offset + 1)
                       parse_tree.push(tmp_array)

               elsif assoc_array[offset][0] == :RParen
                       break

               else
                       parse_tree.push(assoc_array[offset])
               end
               
               offset += 1
       end
       return [offset, parse_tree]
end

#this is a example parse tree for a pn expression, it is 'assembled' below
pn_string = "- * 3 / 15 - 7 + 1 2 + 2 + 1 1"
pn_parse_tree = [:-,[:*,3,[:/,15,[:-,7,[:+,1,2]]]],[:+,2,[:+,1,1]]]

def pn_parse(assoc_array, offset = 0)
        nums = 0
        ops = 0
        parse_tree = []
        while offset < assoc_array.length
                if nums == 2
                        parse_tree.push(assoc_array[offset])
                        break

                elsif ops == 2
                        offset, tmp_array = pn_parse(assoc_array, offset)
                        parse_tree.push(tmp_array)

                else
                        if assoc_array[offset][0] == :Number
                                nums += 1

                        elsif assoc_array[offset][0] == :Operator
                                ops += 1

                        end

                        parse_tree.push(assoc_array[offset])

                end
                
                offset += 1
        end

        return [offset, parse_tree]
end

#this is a example parse for a rpn expression, it is 'assembled' below
rpn_string = "15 7 1 1 + - / 3 * 2 1 1 + + -"
rpn_parse_tree = [[15,[7,[1,1,:+],:-],3,:*],[2,[1,1,:+],:+],:-]      

def rpn_parse(assoc_array, offset = 0)
        return pn_parse(assoc_array.reverse, offset)
end
