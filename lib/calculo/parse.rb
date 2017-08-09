Operator = Struct.new(:precedence, :associativity, :english, :ruby_operator)

class Operator
        def left_associative?
                associativity == :left
        end

        #the < for operators
        def op_<(other)
                if left_associative?
                        precedence <= other.precedence
                else
                        precedence < other.precedence
                end
        end
end

Operators = {
        :re_list => ["+","*","/","%","<",">","^","==","(",")","abs|","ceil|","floor"]
        "+" => Operator.new(2, :left, "ADD", "+")
        "-" => Operator.new(2, :left, "SUB", "-")
        "*" => Operator.new(3, :left, "MUL", "*")
        "/" => Operator.new(3, :left, "DIV", "/")
        "%" => Operator.new(3, :left, "MOD", "%")
        "<" => Operator.new(4, :left, "LT", "<")
        ">" => Operator.new(4, :left, "GT", ">")
        "^" => Operator.new(4, :right, "EXP", "**")
        "==" => Operator.new(4, :none, "EQ?", "eql?")
        "abs" => Operator.new(4, :none, "ABS", "abs")
        "ceil" => Operator.new(4, :none, "CEIL", "ceil")
        "floor" => Operator.new(4, :none, "FLR", "floor")
}

Command = Struct.new(:type,:arg,:desc,:english)
Commands = {
        "p" => Command.new(:stack,"p (NUM)","Print top num values from stack, without changing stack","PRINT")
        "n" => Command.new(:stack,"n (NUM)","Print top num values from stack, and changes stack", "PRINTPOP")
        "P" => Command.new(:stack,"P (NUM)","Pops top num off stack, without printing them", "POP")
        "f" => Command.new(:stack,"f (NUM)","Prints entire contents of stack w/o altering anything","PRINTALL")
        "c" => Command.new(:stack,"c","Clears the stack","CLEAR")
        "r" => Command.new(:stack,"r","Swaps the order of the top two values on the stack","SWAP")

        ";" => Command.new(:repl,";","Represents a new line, allows for multiple statements on same line","NEWLINE")
        "history" => Command.new(:repl,"history (start..end)","Prints the entire history of commands, unless a range is given","HISTORY")
        "clear" => Command.new(:repl,"clear (history)","Clears the screen or the history","CLEAR")
        "exit" => Command.new(:repl,"exit","Exit Calculi","EXIT")
        "quit" => Command.new(:repl,"quit","Quit Calculi","QUIT")
        "help" => Command.new(:repl,"help (command)","Displays help for the program or the command","HELP")

        "=" => Command.new(:var,"variable = NUM","Creates a variable","VAR")
        "+=" => Command.new(:var,"variable += NUM","Adds the NUM to a variable","VARADD")
        "-=" => Command.new(:var,"variable -= NUM","Subtracts the NUM from the variable","VARSUB")
        "*=" => Command.new(:var,"variable *= NUM","Multiplies the variable by the NUM","VARMUL")
        "/=" => Command.new(:var,"variable /= NUM","Divides the variable by the NUM","VARDIV")
}


def parse(string)
        # First regex puts a space after a parenthesis/math operation,
        # Second regex a space between a digit and a parenthesis/math
        # operation(s)
        # Third regex converts any double spaces into single space
        # Fourth regex converts to the exponent operator used in ruby
        # split seperates the characters based on a space

        op_str = '('
        Operators[:re_list].slice(0..-4).each{|x| op_str += "\\#{x}|"}
        Operators[:re_list].take(3).each{|x| op_str += "#{x}"}
        op_str += ')'
        op_re = Regexp.new(op_re_string)
        dig_str = '\d'
        dig_op_str = dig_str + op_re_str + '+'
        dig_op_re = Regexp.new(dig_op_str)
        dig_re = Regexp.new(dig_str + '+')

        array = string.gsub(op_re,'\1 ')
        array = array.gsub(dip_op_re){|s| s.chars.join(' ')}
        array = array.gsub('  ',' ')
        array = array.gsub('^','**')
        array = array.gsub('==', 'eql?')
        array = array.split(' ')

        # Regex finds if array element matches a digit, and converts it
        # to a float.
        array = array.map{|x| dig_re.match(x) != nil ? x.to_f : x}
        return array
end

def lexer(array)
       assoc_array = [] 
       category = 0
       item = 1
       array.each{ |elem|
               if Operators.has_key?(elem)
                       assoc_array.push(["Operator",elem])
               elsif Commands.has_key?(elem)
                       assoc_array.push(["Command",elem])
               elsif /\d+/.match(elem)
                       assoc_array.push(["Number",elem])
               else
                       assoc_array.push(["Nil",elem])
               end
       }
       return assoc_array
end

