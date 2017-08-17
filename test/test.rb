require_relative "../lib/calculo/expr"
require "minitest/autorun"
require 'pry'

class TestLisp < MiniTest::Test
        def setup
                @type = "lisp"
                @string = "( - ( + ( / 18 ( ^ 3 2 ) ) 12 ) 13 )"
                @assoc_array = [[:LParen,"("], [:Operator,"-"], [:LParen, "("], [:Operator, "+"], [:LParen, "("], [:Operator, "/"], [:Number, 18.0], [:LParen, "("], [:Operator, "**"], [:Number, 3.0], [:Number, 2.0], [:RParen, ")"], [:RParen, ")"], [:Number, 12.0], [:RParen, ")"], [:Number, 13.0], [:RParen, ")"]]
                @result = 1
                @Lisp = MathExpression.new(@string, @type)
        end

        def test_type_access
                assert_equal(@type, @Lisp.type)
        end

        def test_string_access
                assert_equal(@string, @Lisp.string)
        end

        def test_array_access
                assert_equal(@assoc_array, @Lisp.assoc_array)
        end

        def test_results
                assert_equal(@result, @Lisp.result)
        end
end

class TestReverseLisp < MiniTest::Test
        def setup
                @type = "reverse-lisp"
                @string = "( 13 ( 12 ( ( 2 3 ^ ) 18 / ) + ) - )"
                @assoc_array = [[:LParen, "("], [:Number, 13.0], [:LParen, "("], [:Number, 12.0], [:LParen, "("], [:LParen, "("], [:Number, 2.0], [:Number, 3.0], [:Operator, "**"], [:RParen, ")"], [:Number, 18.0], [:Operator, "/"], [:RParen, ")"], [:Operator, "+"], [:RParen, ")"], [:Operator, "-"], [:RParen, ")"]]
                @result = 1
                @ReverseLisp = MathExpression.new(@string, @type)
        end

        def test_type_access
                assert_equal(@type, @ReverseLisp.type)
        end

        def test_string_access
                assert_equal(@string, @ReverseLisp.string)
        end

        def test_array_access
                assert_equal(@assoc_array, @ReverseLisp.assoc_array)
        end

        def test_results
                assert_equal(@result, @ReverseLisp.result)
        end
end

class TestPN < MiniTest::Test
        def setup
                @type = "pn"
                @string = "- + / 18 ^ 3 2 12 13"
                @assoc_array = [[:Operator, '-'], [:Operator, '+'], [:Operator, '/'], [:Number, 18.0], [:Operator, '**'], [:Number, 3.0],[:Number, 2.0],[:Number, 12.0], [:Number, 13.0]]
                @result = 1
                @PN = MathExpression.new(@string, @type)
        end

        def test_type_access
                assert_equal(@type, @PN.type)
        end

        def test_string_access
                assert_equal(@string, @PN.string)
        end

        def test_array_access
                assert_equal(@assoc_array, @PN.assoc_array)
        end

        def test_result_access
                assert_equal(@result, @PN.result)
        end
end

class TestRPN < MiniTest::Test
        def setup
                @type = "rpn"
                @string = "12 18 3 2 ^ / 13 - +"
                @assoc_array = [[:Number, 12.0], [:Number, 18.0], [:Number, 3.0],[:Number, 2.0], [:Operator, "**"], [:Operator, "/"], [:Number, 13.0], [:Operator, "-"], [:Operator, "+"]]
                @result = 1
                @RPN = MathExpression.new(@string, @type)
        end

        def test_string_access
                assert_equal(@string, @RPN.string)
        end

        def test_array_access
                assert_equal(@assoc_array, @RPN.assoc_array)
        end

        def test_result_access
                assert_equal(@result, @RPN.result)
        end
end

class TestInfix < MiniTest::Test
        def setup
                @type = "rpn" 
                @string = "12 + 18 / ( 3 ^ 2 ) - 13"
                @assoc_array = [[:Number, 12.0], [:Number, 18.0], [:Number, 3.0],[:Number, 2.0], [:Operator, "**"], [:Operator, "/"], [:Number, 13.0], [:Operator, "-"], [:Operator, "+"]]
                @result = 1
                @Infix = MathExpression.new(@string, "infix")
        end

        def test_type
                assert_equal(@type, @Infix.type)
        end

        def test_string_access
                assert_equal(@string, @Infix.string)
        end

        def test_shunting_yard
                assert_equal(@assoc_array, @Infix.assoc_array)
        end

        def test_result_access
                assert_equal(@result, @Infix.result)
        end
end
