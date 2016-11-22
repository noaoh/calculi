require_relative "lib/calculi"
require "minitest/autorun"

class TestLisp < Minitest::Test
        def setup
                @CalculiLisp = Calculi.new("(/ 4 (+ 3 (- 2 1)))", "lisp")
                @Lisp = Lisp.new("(/ 4 (+ 3 (- 2 1)))", "lisp")
        end

        def test_type_access
                assert_equal("lisp", @CalculiLisp.type)
                assert_equal("lisp", @Lisp.type)
        end

        def test_string_access
                assert_equal("(/ 4 (+ 3 (- 2 1)))", @CalculiLisp.string)
                assert_equal("(/ 4 (+ 3 (- 2 1)))", @Lisp.string)
                assert_equal(@CalculiLisp.string, @Lisp.string)
        end

        def test_string_gets_parsed
                assert_equal(["(", "/", 4.0, "(", "+", 3.0, "(", "-", 2.0, 1.0, ")", ")", ")"], @CalculiLisp.parse)
                assert_equal(["(", "/", 4.0, "(", "+", 3.0, "(", "-", 2.0, 1.0, ")", ")", ")"], @Lisp.parse)
                assert_equal(@CalculiLisp.parse, @Lisp.parse)
        end

        def test_array_access
                assert_equal(["(", "/", 4.0, "(", "+", 3.0, "(", "-", 2.0, 1.0, ")", ")", ")"], @CalculiLisp.array)
                assert_equal(["(", "/", 4.0, "(", "+", 3.0, "(", "-", 2.0, 1.0, ")", ")", ")"], @Lisp.array)
                assert_equal(@CalculiLisp.array, @Lisp.array)
        end

        def test_indices_finder
                assert_equal([[6,10], [4,11], [0,12]], @CalculiLisp.indices_finder)
                assert_equal([[6,10], [4,11], [0,12]], @Lisp.indices_finder)
                assert_equal(@CalculiLisp.indices_finder, @Lisp.indices_finder)
        end

        def test_indices_access
                assert_equal([[6,10], [4,11], [0,12]], @CalculiLisp.indices)
                assert_equal([[6,10], [4,11], [0,12]], @Lisp.indices)
                assert_equal(@CalculiLisp.indices, @Lisp.indices)
        end

        def test_eval
                assert_equal(1, @CalculiLisp.eval)
                assert_equal(1, @Lisp.eval)
                assert_equal(@CalculiLisp.result, @Lisp.result)
        end
end

class TestReverseLisp < Minitest::Test
        def setup
                @CalculiReverseLisp = Calculi.new("(((1 2 -) 3 +) 4 /)", "reverse-lisp")
                @ReverseLisp = Lisp.new("(((1 2 -) 3 +) 4 /)", "reverse-lisp")
        end

        def test_string_access
                assert_equal("(((1 2 -) 3 +) 4 /)", @CalculiReverseLisp.string)
                assert_equal("(((1 2 -) 3 +) 4 /)", @ReverseLisp.string)
                assert_equal(@CalculiReverseLisp.string, @ReverseLisp.string)
        end

        def test_type_access
                assert_equal("lisp", @CalculiReverseLisp.type)
        end
        def test_string_gets_parsed
                assert_equal(["(", "(", "(", 1.0, 2.0, "-", ")", 3.0, "+", ")", 4.0, "/", ")"], @CalculiReverseLisp.parse)
                assert_equal(["(", "(", "(", 1.0, 2.0, "-", ")", 3.0, "+", ")", 4.0, "/", ")"], @ReverseLisp.parse)
                assert_equal(@CalculiReverseLisp.parse, @ReverseLisp.parse)
        end

        def test_array_access
                assert_equal(["(", "(", "(", 1.0, 2.0, "-", ")", 3.0, "+", ")", 4.0, "/", ")"], @CalculiReverseLisp.array)
                assert_equal(["(", "(", "(", 1.0, 2.0, "-", ")", 3.0, "+", ")", 4.0, "/", ")"], @ReverseLisp.array)
                assert_equal(@CalculiReverseLisp.array, @ReverseLisp.array)
        end

        def test_indices_finder
[[10, 6], [11, 4], [12, 0]]
                assert_equal([[10, 6], [11, 4], [12, 0]], @CalculiReverseLisp.indices_finder)
                assert_equal([[10, 6], [11, 4], [12, 0]], @ReverseLisp.indices_finder)
                assert_equal(@CalculiReverseLisp.indices_finder, @ReverseLisp.indices_finder)
        end

        def test_indices_access
                assert_equal(@CalculiReverseLisp.indices)
                assert_equal(@ReverseLisp.indices)
                assert_equal(@CalculiReverseLisp.indices, @ReverseLisp.indices)
        end

        def test_eval
                assert_equal(1, @CalculiReverseLisp.eval)
                assert_equal(1, @ReverseLisp.eval)
                assert_equal(@CalculiReverseLisp.result, @ReverseLisp.result)
        end
end

class TestPN < Minitest::Test
        def setup
                @CalculiPN = Calculi.new("/ + - 2 1 3 4", "pn")
                @PN = MathNotation.new("/ + - 2 1 3 4", "pn")
        end

        def test_string_access
                assert_equal("/ + - 2 1 3 4", @CalculiPN.string)
                assert_equal("/ + - 2 1 3 4", @PN.string)
                assert_equal(@Calculi.string, @PN.string)
        end

        def test_parse
                assert_equal(["/", "+", "-", 2.0, 1.0, 3.0, 4.0], @CalculiPN.parse)
                assert_equal(["/", "+", "-", 2.0, 1.0, 3.0, 4.0], @PN.parse)
        end

        def test_array_access
                assert_equal(["/", "+", "-", 2.0, 1.0, 3.0, 4.0], @CalculiPN.array)
                assert_equal(["/", "+", "-", 2.0, 1.0, 3.0, 4.0], @PN.array)
                assert_equal(@CalculiPN.array, @PN.array)
        end

        def test_indices_finder
                assert([0,1,2], @CalculiPN.indices_finder)
                assert([0,1,2], @PN.indices_finder)
        end

        def test_indices_access
                assert_equal([0,1,2], @CalculiPN.indices)
                assert_equal([0,1,2], @PN.indices)
                asssert_equal(@CalculiPN.indices, @PN.indices)
        end

        def test_eval
                assert_equal(1, @CalculiPN.eval)
                assert_equal(1, @PN.eval)
                assert_equal(@CalculiPN.result, @PN.result)
        end
end

class TestRPN < Minitest::Test
        def setup
                @CalculiRPN = Calculi.new("4 3 1 2 - + /", "rpn")
                @RPN = MathNotation.new("4 3 1 2 - + /", "rpn")
        end

        def test_string_access
                assert_equal("4 3 1 2 - + /", @CalculiPN.string)
                assert_equal("4 3 1 2 - + /", @PN.string)
                assert_equal(@Calculi.string, @PN.string)
        end

        def test_parse
                assert_equal([4.0, 3.0, 1.0, 2.0, "-", "+", "/"], @CalculiPN.parse)
                assert_equal([4.0, 3.0, 1.0, 2.0, "-", "+", "/"], @PN.parse)
        end

        def test_array_access
                assert_equal(@CalculiPN.array)
                assert_equal(@PN.array)
                assert_equal(@CalculiPN.array, @PN.array)
        end

        def test_indices_finder
                assert([2,1,0], @CalculiPN.indices_finder)
                assert([2,1,0], @PN.indices_finder)
        end

        def test_indices_access
                assert_equal([2,1,0], @CalculiPN.indices)
                assert_equal([2,1,0], @PN.indices)
                asssert_equal(@CalculiPN.indices, @PN.indices)
        end

        def test_eval
                assert_equal(1, @CalculiPN.eval)
                assert_equal(1, @PN.eval)
                assert_equal(@CalculiPN.eval, @PN.eval)
        end

        def test_result_access
                assert_equal(1, @CalculiPN.result)
                assert_equal(1, @PN.result)
                assert_equal(@CalculiPN.result, @PN.result)
        end
end
