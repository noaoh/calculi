symbol_table = {'numbers' => [1,2,3,4,5,6,7,8,9], 'operators' => ['+', '-', '*', '/', '^', '%', '>', '<']}
infix_operator_precendence = {'+' => 2, '-' => 2, '*' => 3, '/' => 3, '^' => 4}

def parse_string(string):
        array = string.split(' ')
        hash = array.each_with_index.to_h
end

def calculi_eval(array, type)
end

def eval_pn_list(operator, num1, num2):
        num1.method(operator).call(num2)
end

def eval_rpn_list(num1, num2, operator):
        num2.method(operator).call(num1)
end

def eval_infix_list(num1, operator, num2):
        num1.method(operator).call(num2)
end
