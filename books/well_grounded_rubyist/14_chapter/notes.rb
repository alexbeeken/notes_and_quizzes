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

# eval can execute strings as code

# prints 4
puts eval("2+2")

print "Choose a method name: "
# m = gets.chomp
m = "dyanmic_method"
eval("def #{m}; puts 'hi'; end")
eval(m)

# The Binding class encapsulates current scope
def use_a_binding(b)
  eval('puts str', b)
end

str = 'hello world'
use_a_binding(binding)
# the method above should use the str variable

# self is main in this context
p self
a = []
a.instance_eval { p self }

# you can pass an argument to instance_exec
a = "Example String"
p a.instance_exec("a") { |d| self.split(d) }

# class_eval puts you inside of a class defition
c = Class.new
c.class_eval do
  def some_method
    puts 'inside class'
  end
end
c = c.new
c.some_method

# The class keyword does not use variables in the scope
# You wont see the string but you will see the error
begin
  str = 'string in this context'
  class C
    puts str
  end
rescue
  puts "ERROR trying to use local variable in class"
end

# Now it works
C.class_eval { puts str }

# Let's combine this with def
begin
  foo = "instance method"
  C.class_eval { def talk; puts foo; end }
  C.new.talk
rescue
  puts "ERROR - def inside class eval string is out of scope"
end

# now it works
# and define_method returns a proc object
C.class_eval { define_method('talk') { puts foo }}
C.new.talk

# doesn't finish because
# it sleeps too long for the it to execute the second puts
t = Thread.new do
  puts 'inside the thread 1'
  sleep 1
  puts 'end of the thread 1'
end

t.join
puts "outside the thread 1"
t.kill

# we need to assign it to a variable
# in order to get it working
t = Thread.new do
  puts 'inside the thread 2'
  sleep 0.2
  puts 'end of the thread 2'
end

puts 'outside thread 2'
t.join
t.kill

# you can stop threads from inside their execution

puts 'attempt to open some files'
t = Thread.new do
  (0..2).each do |n|
    begin
      puts "trying to open #{n}"
      File.open("File0#{n}") do |f|
        text << f.readlines
      end
    rescue
      puts "Failed on n=#{n}"
      Thread.exit
    end
  end
end

t.join
puts 'Thread 3 finished'
t.kill

# the four state of a thread are
# awake
# asleep
# alive
# dead

t = Thread.new do
  puts 'thread 4 starting'
  Thread.stop
  puts 'thread 4 resuming'
end

puts "status of thread 4: #{t.status}"
puts "is thread 4 stopped?: #{t.stop?}"
puts 'thread 4 finished'
puts
puts 'waking up thread and joining it...'
t.wakeup
t.join
puts
puts "Is this alive? #{t.alive?}"
puts "Inspect string for thread: #{t.inspect}"
t.kill

# Fibers can return to their calling block several times

f = Fiber.new do
  puts 'first block'
  Fiber.yield
  puts 'second block'
  Fiber.yield
  puts 'third block'
end
puts 'starting fiber'
f.resume
puts 'intermission'
f.resume
puts 'finale'
f.resume
puts 'go home'

# when variables in local scope changes are permanent
a = 1
puts a
t = Thread.new { a = 2}
t.run
puts a

# Still changes variable even after Thread.stop
a = 1
t = Thread.new { Thread.stop; a = 2}
puts a
t.run
puts a

# global variables are still global
$var = "$var unchanged global"
puts $var
a = Thread.new { $var = "new $var global value" }
a.join
puts $var
a.kill

# stays the same if I run .join but not if I run .run

# some globals are thread-local like $1
/(abc)/.match "abc"

t = Thread.new do
  /(def)/.match("def")
  puts "$1 in thread: #{$1}"
end.join

puts "$1 outside of thread #{$1}"
t.kill

# Threads have thread keys
t = Thread.new do
  Thread.current[:message] = 'Hello'
end

t.join
t.kill

# array of key names
p t.keys
puts t[:message]
t.kill

system('date')
print '$? outside is'
p $?

t = Thread.new { system('fiesta'); print 'inside $? is:'; p $? }
t.join
print '$? outside is'
p $?
t.kill

# call a system command with backticks

d = `date`
print 'date is '
p d

# you can also call system commands like this:

d = %x{date}
p d

# you can use other delimeters if you want

d = %x-date-
p d

# you can interpolate commands
# ... but you should not

d = 'date'
p %x{#{d}}
p `#{d}`

# you can also use open and popen3 to communicate
# with other programs

# d = open('|cat', 'w+')

# |cat indicates that we're opening another program
# and not a file
# d.puts 'hello world'
# d.gets 'hello world\n'
# d.close
