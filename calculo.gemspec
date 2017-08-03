Gem::Specification.new do |s|
        s.name = "calculo"
        s.version = "1.0.0"
        s.date = "2017-08-03"
        s.required_ruby_version = '>=2.0.0'
        s.summary = "A calculator for the command line"
        s.description = "A calculator for the command line supporting postfix, prefix, infix, and lisp notation (plus a REPL)"
        s.authors = ["Noah Holt"]
        s.email = "noahryanholt@gmail.com"
        s.files = ["Rakefile","README.md","test/test.rb","lib/calculo.rb","lib/calculo/lisp.rb","lib/calculo/parse.rb","lib/calculo/math.rb","lib/calculo/shunting_yard.rb","lib/calculo/repl.rb","bin/calculo"]
        s.require_paths = ["lib","bin","test","lib/calculo"]
        s.executables = ["calculo"]
        s.homepage = "https://github.com/noaoh/calculo"
        s.license = "GPLv3"
        s.add_dependency('os')
end
