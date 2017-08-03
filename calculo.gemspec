Gem::Specification.new do |s|
        s.name = "calculo"
        s.version = "1.0.0"
        s.date = "2017-08-01"
        s.required_ruby_version = '>=2.0.0'
        s.summary = "A calculator for the command line"
        s.description = "A calculator for the command line supporting postfix, prefix, infix, and lisp notation (plus a REPL)"
        s.authors = ["Noah Holt"]
        s.email = "noahryanholt@gmail.com"
        s.files = ["Rakefile","README.md","test/test.rb","lib/lisp.rb","lib/parse.rb","lib/math.rb","lib/shunting_yard.rb","lib/repl.rb","bin/calculo"]
        s.executables = ["bin/calculo","calculo"]
        s.homepage = "https://github.com/noaoh/calculo"
        s.license = "GPLv3"
        s.add_dependency('os')
end
