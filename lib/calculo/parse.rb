def parse(string)
        # First regex puts a space after a parenthesis/math operation,
        # Second regex a space between a digit and a parenthesis/math
        # operation(s)
        # Third regex converts any double spaces into single space
        # Fourth regex converts to the exponent operator used in ruby
        # split seperates the characters based on a space

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
