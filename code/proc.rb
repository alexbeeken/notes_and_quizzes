require 'pry'
foo = Proc.new { puts "hello world!" }

foo.call

double = Proc.new { |x| x + x }

puts double.call(2)

# shorthand that used to do something different but is now the same
triple = proc { |x| x * 3 }

puts triple.call(3)

def call_a_proc(&block)
  puts "calling before the block runs"
  block.call
end

call_a_proc { puts "inline block"}

call_a_proc do
  puts "multiline block"
end

the_proc = proc { |x| print " #{x} "}

# can stand in for a method's code block
['dwayne', 'the', 'proc', 'johnson', "\n"].map &the_proc

bopit = {
  bop: proc { |x| print " #{x} bop it" },
  twist: proc { |x| print " #{x} twist it" },
  turn: proc { |x| print " #{x} turn it" },
  pass: proc { |x| print " #{x} pass it" }
}

bopit.keys.shuffle.each { |k| bopit[k].call }
print "\n"

# implement to_proc on a custom class to define it's behavior
class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end

  def self.to_proc
    Proc.new { |name| Person.new(name) }
  end
end
pp = Proc.new { |person| p person.name }
%w|bob rob todd|.map(&Person).map(&pp)

# see how m is defined by the context of the method def?
def multiply_by(m)
  Proc.new { |x| x * m }
end

mult = multiply_by(10)
puts mult.call(2)

# lets put it more explicitly
# a is defined here in two different scopes
# and this doesnt affect either one
def call_some_proc(pr)
  a = "irrelevent 'a' in method scope"
  puts a
  pr.call
end

a = "'a' to be used in proc block"
pr = Proc.new { puts a }
pr.call
call_some_proc(pr)

# classic Proc example
def make_counter
  x = 0
  return proc { x += 1 }
end

# should print 2
# preserves some state from creation
c = make_counter
c.call
puts c.call

# should print 1
# resets state
d = make_counter
puts d.call

# procs can take arguments
pr = Proc.new { |x| puts "Called with argument #{x}" }
pr.call(100)

# procs dont check for argument numbers like methods do
# you can call this and the output is the same as above
pr.call(100, 'ardvark', ['halleluja'], 42, 1.2)

# no arguments just returns nil
pr.call

# you can splat all arguments
pr = proc { |*x| p x }

# they come in as an array
pr.call(100, 'ardvark', ['halleluja'], 42, 1.2)

# you can splat first or last
pr = proc { |x, *y| p x; p y; }
pr.call(100, 'ardvark', ['halleluja'], 42, 1.2)

pr = proc { |*x, y| p x; p y; }
pr.call(100, 'ardvark', ['halleluja'], 42, 1.2)

# you can get all middle arguments
pr = proc { |j, *x, y| p j; p x; p y; }
pr.call(100, 'ardvark', ['halleluja'], 42, 1.2)

# can't do this
# pr = proc { |j, *x, *m, y| p j; p x; p m; p y; }
# pr.call(100, 'ardvark', ['halleluja'], 42, 1.2)
# gives a syntax error

lam = lambda { puts "Mylambda!" }
lam.call

def return_test
  l = lambda { return }
  l.call
  puts "still goin"
  p = proc { return }
  p.call
  puts "this WILL NOT SHOW here is my social security number: 123456789101010101"
end

return_test

# calling return from a non method context produces an error
# ruby -e 'Proc.new { return }.call'

# lambdas check for number of arguments
# lam = lambda { |j, x, y| p j; p x; p y; }
# lam.call(100, 'ardvark', ['halleluja'], 42, 1.2)

# methods as arguments

class C
  def talk
    puts "Method grabbing test! self is #{self}"
  end
end

c = C.new
meth = c.method(:talk)

# meth is a method object
meth.call

# unbind the method object
class D < C
end

# bind the method to a new object
d = D.new
unbound = meth.unbind
unbound.bind(d).call

# gives you a method object that is not bound to an instance
unbound = C.instance_method(:talk)

# you can assign the instance later
unbound.bind(d)

# but WHYYY use this instance_method stuff?
class X
  def a_method
    puts "X a_method"
  end
end

class Y < X
  def a_method
    puts "Y a_method"
  end
end

class Z < Y
end

c = Z.new
c.a_method
# will return first matching instance of instance_method
# from the class hierarchy (class Y)

# you can get the original method from X directly
# ask for the method by name and bind it to the
# object and call it
X.instance_method(:a_method).bind(c).call

# or put it in another method
class Z < Y
  def call_original
    X.instance_method(:a_method).bind(c).call
  end
end
# YOU SHOULDN'T REALLY DO THIS THOUGH
