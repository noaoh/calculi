require_relative "../lib/lisp"
require_relative "../lib/math"
require "minitest/autorun"

class TestLisp < MiniTest::Test
        def setup
                @type = "lisp"
                @string = "( - ( + ( / 18 ( ^ 3 2 ) ) 12 ) 13 )"
                @array = ["(", "-", "(", "+", "(", "/", 18.0, "(", "**", 3.0, 2.0, ")", ")", 12.0, ")", 13.0, ")"]
                @result = 1
                @Lisp = Lisp.new(@string, @type)
        end

        def test_type_access
                assert_equal(@type, @Lisp.type)
        end

        def test_string_access
                assert_equal(@string, @Lisp.string)
        end

        def test_array_access
                assert_equal(@array, @Lisp.array)
        end

        def test_results
                assert_equal(@result, @Lisp.result)
        end
end

class TestReverseLisp < MiniTest::Test
        def setup
                @type = "reverse-lisp"
                @string = "( 13 ( 12 ( ( 2 3 ^ ) 18 / ) + ) - )"
                @array = ["(", 13.0, "(", 12.0, "(", "(", 2.0, 3.0, "**", ")", 18.0, "/", ")", "+", ")", "-", ")"]
                @result = 1
                @ReverseLisp = Lisp.new(@string, @type)
        end

        def test_type_access
                assert_equal(@type, @ReverseLisp.type)
        end

        def test_string_access
                assert_equal(@string, @ReverseLisp.string)
        end

        def test_array_access
                assert_equal(@array, @ReverseLisp.array)
        end

        def test_results
                assert_equal(@result, @ReverseLisp.result)
        end
end

class TestPN < MiniTest::Test
        def setup
                @type = "pn"
                @string = "- + / 18 ^ 3 2 12 13"
                @array = ['-', '+', '/', 18.0, '**', 3.0, 2.0, 12.0, 13.0]
                @result = 1
                @PN = MathNotation.new(@string, @type)
        end

        def test_type_access
                assert_equal(@type, @PN.type)
        end

        def test_string_access
                assert_equal(@string, @PN.string)
        end

        def test_array_access
                assert_equal(@array, @PN.array)
        end

        def test_result_access
                assert_equal(@result, @PN.result)
        end
end

class TestRPN < MiniTest::Test
        def setup
                @type = "rpn"
                @string = "12 18 3 2 ^ / 13 - +"
                @array = [12.0, 18.0, 3.0, 2.0, "**", "/", 13.0, "-", "+"]
                @result = 1
                @RPN = MathNotation.new(@string, @type)
        end

        def test_string_access
                assert_equal(@string, @RPN.string)
        end

        def test_array_access
                assert_equal(@array, @RPN.array)
        end

        def test_result_access
                assert_equal(@result, @RPN.result)
        end
end

class TestInfix < MiniTest::Test
        def setup
                @type = "rpn" 
                @string = "12 + 18 / ( 3 ^ 2 ) - 13"
                @rpn_array = [12.0, 18.0, 3.0, 2.0, "**", "/", 13.0, "-", "+"]
                @result = 1
                @Infix = MathNotation.new(@string, "infix")
        end

        def test_type
                assert_equal(@type, @Infix.type)
        end

        def test_string_access
                assert_equal(@string, @Infix.string)
        end

        def test_shunting_yard
                assert_equal(@rpn_array, @Infix.array)
        end

        def test_result_access
                assert_equal(@result, @Infix.result)
        end
end
