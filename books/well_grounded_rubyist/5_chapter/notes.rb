class C
  a = 5
  module M
    a = 4
    module N
      a = 3
      class D
        a = 2
        def show_a
          a = 1
          puts a
        end
        puts a
      end
      puts a
    end
    puts a
  end
  puts a
end

d = C::M::N::D.new
d.show_a
# output is 2,3,4,5,1

puts __LINE__

# recursion and scope in ruby

class C
  def x(value_for_a, recurse=false)
    a = value_for_a
    print "Here's the inspection string for self:"
    p self
    puts "and here's a:"
    puts a
    if recurse
      puts "Recursing by calling myself..."
      x("Second value for a")
      puts "Back after recursion: here's a:"
      puts a
    end
  end
end

c = C.new
c.x("First value for a", true)

puts __LINE__

# Now with object ids instead of variable values

class C
  def x(value_for_a, recurse=false)
    a = value_for_a
    print "Here's the inspection string for self:"
    p self.object_id
    puts "and here's a:"
    puts a.object_id
    if recurse
      puts "Recursing by calling myself..."
      x("Second value for a")
      puts "Back after recursion: here's a:"
      puts a.object_id
    end
  end
end

c = C.new
c.x("First value for a", true)

puts __LINE__

# Class variables actually have a use!

class Car
  @@makes = []
  @@cars = {}
  @@total_count = 0

  attr_reader :make

  def self.total_count
    @@total_count
  end

  def self.add_make(make)
    unless @@makes.include?(make)
      @@makes << make
      @@cars[make] = 0
    end
  end

  def initialize(make)
    if @@makes.include?(make)
      puts "Creating a new #{make}!"
      @make = make
      @@cars[make] += 1
      @@total_count += 1
    else
      raise "No such make: #{make}."
    end
  end

  def make_mates
    @@cars[self.make]
  end
end

Car.add_make("Honda")
Car.add_make("Ford")

h = Car.new("Honda")
f = Car.new("Ford")
h2 = Car.new("Honda")

puts "Counting cars of the same make as h2..."
puts "There are #{h2.make_mates}."

puts "Counting total cars..."
puts "There are #{Car.total_count} cars."

# raises an error
# x = Car.new("Tesla")

puts __LINE__

# Class variables are class hierarchy variables.
# This means they do things that people dont like sometimes.

class Parent
  @@value = 100
end

class Child < Parent
  @@value = 200
end

class Parent
  puts @@value
end

puts __LINE__

# protected methods are good for interclass comparisons

class C
  def initialize(n)
    @n = n
  end

  def n
    @n
  end

  def compare(c)
    if c.n > n
      puts "The other object's n is bigger."
    else
      puts "The other object's n is same or smaller"
    end
  end

  protected :n
end

c = C.new(5)
x = C.new(3)

c.compare(x)

puts __LINE__

# top levels methods are private methods on Object

def talk
  puts "say hello"
end

# is the same as...

class Object
  private
  def talk
    puts "hello again"
  end
end

# these methods can only be called bare word style

# this works and says "hello again"
talk

# fails with an error because it uses an explicit receiver
# Object.new.talk

puts __LINE__
