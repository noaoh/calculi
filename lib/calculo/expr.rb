require_relative 'eval'
require 'pry'

class MathExpression
        attr_accessor :type
        attr_accessor :string
        attr_accessor :assoc_array
        attr_accessor :result

        def initialize(string,type)
                @string = string
                @type = type
                @assoc_array = lexer(tokenize(@string))
                @result = calculi_eval(@assoc_array,@type)
        end
end
