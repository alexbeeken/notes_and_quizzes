class Cookbook
  attr_accessor :recipes

  def initialize
    @recipes = []
  end

  def method_missing(m, *args, &block)
    @recipes.send(m, *args, &block)
  end
end

# This is a simple metaprogramming technique to fallback on recpies for method calls.

# this allows you to do somehting

class Recipe
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

puts 'recipes'
cb = Cookbook.new
cb << Recipe.new('cake')
cb << Recipe.new('brownies')
cb.recipes.map {|r| puts r.name }
puts __LINE__

# the methods for array are delegated through method_missing
# this is delegation

# when including a module,
# a method called included is triggered

module M
  def self.included(c)
    puts "I was just included into #{c}."
  end
end

class C
  include M
end
puts __LINE__

# So when would you use this?

module M
  def self.included(c)
    def c.a_class_method
      puts "A new class method inside of M."
    end
  end

  def an_instance_method
    puts "an instance method inside M"
  end
end

class C
  include M
end

c = C.new
c.an_instance_method
C.a_class_method

puts __LINE__

# you can also ecxtend any object instance

obj = Object.new
obj.extend(M)
obj.an_instance_method

puts __LINE__

# extending an instance triggers two different
# callbacks in the module

module M
  def self.included(obj)
    puts "#{self} included by #{obj}"
  end

  def self.extended(obj)
    puts "#{self} extended by #{obj}"
  end

  def an_instance_method
    puts "an instance method inside M"
  end
end

obj = Object.new
puts 'including M in class'
class << obj
  include M
end

puts 'extending obj with M'
obj.extend(M)

puts __LINE__

# classes can do the same thing when subclasses

class C
  def self.inherited(subclass)
    puts "#{self} just got subclassed by #{subclass}"
  end
end

class D < C
end

puts __LINE__

# This cascades up the chain of inheritance.

class E < D
end

puts __LINE__

# there are limits to this

class C
  class << self
    def self.inherited
      puts 'Singleton class of C just got inherited'
      puts 'but YOU WONT SEE THIS MESSAGE'
    end
  end
end

class D < C
  class << self
    puts "D's singleton class now exists but no callback"
  end
end

# the callback is not called for the singleton of D

puts __LINE__

# you can use const_missing to define constants

class C
  def self.const_missing(const)
    puts "#{const} doesnt exist so setting it to 1"
    const_set(const, 1)
  end
end

puts C::A

puts __LINE__

# method_added allows you to trigger an event
# when a new isntance method is defined

class C
  def self.method_added(m)
    puts "Method #{m} was defined."
  end

  def a_new_method
  end
end

# this should print out a_new_method
# method_added is called when an instance method is defined

puts __LINE__

class C
  def self.singleton_method_added(m)
    puts "The class method: #{m} was just defined"
  end
end

# same thing but for singleton methods
# including itself

puts __LINE__

class C
  def self.singleton_method_added(m)
    puts "The class method: #{m} was just defined"
  end

  def self.a_new_class_method
  end
end

puts __LINE__

obj = Object.new

def obj.singleton_method_added(m)
  puts "#{m} was just defined"
end

def obj.a_new_singleton_method
end

# you should do this in most cases
# not sure why though -
# EDIT: maybe its because it only applies that
# definition to the instance of that singleton?
# still confused

puts __LINE__

obj = Object.new

class << obj
  def singleton_method_added(m)
    puts "singleton method: #{m} added"
  end

  def a_new_singleton_method
  end
end

puts __LINE__

# you can also define singleton_method_added
# as an instance method

class C
  def singleton_method_added(m)
    puts "Singletone method #{m} was just defined."
  end
end

c = C.new

def c.a_new_singleton_method
  puts "called a new singleton method"
end

# the one below throws an error
# C.a_new_singleton_method
c.a_new_singleton_method

puts __LINE__

# you can use the methods method to examine lists of methods

string = "hello"
puts 'list of "case" methods on String'
p string.methods.grep(/case/,).sort

puts __LINE__

# get all the bang methods

puts 'list of bang methods for string'
bang_methods = string.methods.grep(/.!/).sort
p bang_methods

puts __LINE__

# lets check if any methods dont have matching non bang methods'

unmatched = bang_methods.reject do |bm|
  string.methods.include?(bm[0..-2].to_sym)
end

if unmatched.empty?
  puts 'All bang methods have non bang methods'
else
  puts 'These methods dont have non bang equivalents'
  p unmatched
end

# output should show that they do all have matching non bangers

puts __LINE__

# lets make it not match for fun

def string.surprise!
end

bang_methods = string.methods.grep(/.!/).sort

unmatched = bang_methods.reject do |bm|
  string.methods.include?(bm[0..-2].to_sym)
end

if unmatched.empty?
  puts 'All bang methods have non bang methods'
else
  puts 'These methods dont have non bang equivalents'
  p unmatched
end

# should show [:suprise!] in the list of non matching

puts __LINE__

# you will see all the methods that a class or object knows about
# not the methods that are defined in the class or obj

class S
end

p S.methods.size

# lots of methods

puts __LINE__

obj = Object.new

puts 'private methods:'
puts obj.private_methods.size
puts 'protected_methods:'
puts obj.protected_methods.size

puts __LINE__

class Person
  attr_reader :name
  def name=(name)
    @name = name
    normalize_name
  end

  private

  def normalize_name
    @name.gsub!(/[^-a-z'.\s]/i, "")
  end
end

alex = Person.new
puts 'input is Alex#@#@!21312131 Beeke!@#@!12n'
alex.name = 'Alex#@#@!21312131 Beeke!@#@!12n'
raise 'Name is bad' unless alex.name == 'Alex Beeken'
puts "The normalized name is #{alex.name}."

p alex.private_methods.grep(/normal/)

# the name is here inside the private methods list

puts __LINE__

# respond_to? obly works on public methods

p alex.respond_to?(:normalize_name) # false
p alex.respond_to?(:name=) # true

puts __LINE__

p String.methods.grep(/methods/).sort

# notice these four

p String.methods.grep(/instance_methods/).sort

puts 'methods:'
p String.methods.count

puts 'instance methods:'
p String.instance_methods.count

puts 'public instance methods:'
p String.public_instance_methods.count

puts 'private instance methods:'
p String.private_instance_methods.count

puts 'protected instance methods:'
p String.protected_instance_methods.count

puts __LINE__

# to find out which methods are overriden on two classes

# you can passs in false to limit scope to just these Classes
# and not on any ancestors of the two

p Range.instance_methods(false) & Enumerable.instance_methods(false)

puts __LINE__

# lets find out all overrides on all classes that mix in enumerable

overrides = {}
enum_classes = ObjectSpace.each_object(Class).select do |c|
  c.ancestors.include? (Enumerable)
end

enum_classes.each do |c|
  p c.instance_methods(false)
  overrides[c] = c.instance_methods(false) &
    Enumerable.instance_methods(false)
end

overrides.delete_if {|c, methods| methods.empty?}
overrides.each do |c, methods|
  puts "Class #{c} overrides: #{methods.join(', ')}"
end

# for some reason sort_by was comparing with nil
# I left it unsorted

puts __LINE__

# listing singleton methods

class C
end

c = C.new

class << c
  def x
  end

  def y
  end

  def z
  end

  protected :y
  private :z
end

p c.singleton_methods.sort

puts __LINE__

# to find out what methods file inherits from ancestors
# as opposed to those it defines itself...

p File.singleton_methods - File.singleton_methods(false)

puts __LINE__

# lets talk about variable scope and these types of inspections

x = 1

# shows :x and all the reast of the file
p local_variables

# shows a lot more, even though this file is 400+ lines long
p global_variables

puts __LINE__

class Person
  attr_accessor :name, :age
  def initialize(name)
    @name = name
  end
end

alex = Person.new('Alex')
alex.age = 29

p alex.instance_variables

# shows the two @name and @age variables

puts __LINE__

# the chief tool for finding call history is caller

# see tracedemo.rb for actual code
