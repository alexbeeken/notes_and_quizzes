
module Stacklike
  def stack
    @stack ||= []
  end

  def add_to_stack(obj)
    stack.push(obj)
  end

  def take_from_stack
    stack.pop
  end
end

class Stack
  include Stacklike
end

s = Stack.new

s.add_to_stack "item one"
s.add_to_stack "item two"
s.add_to_stack "item three"

puts "Objects currently in the stack:"
puts s.stack

taken = s.take_from_stack
puts "Removed this object!"
puts taken

puts "Now on stack:"
puts s.stack

puts __LINE__

# lets use the analogy of a suitcase as a LIFO
# or a stacklike real world process

class SuitCase
end

class CargoHold
  include Stacklike

  def load_and_report(obj)
    print 'Loading object '
    puts obj.object_id
    add_to_stack(obj)
  end

  def unload
    take_from_stack
  end
end

ch = CargoHold.new
sc1 = SuitCase.new
sc2 = SuitCase.new
sc3 = SuitCase.new

ch.load_and_report(sc1)
ch.load_and_report(sc2)
ch.load_and_report(sc3)

first_unloaded = ch.unload

print "the first suitcase off the plane is..."
puts first_unloaded.object_id

puts __LINE__

# let's checkout method lookup

module M
  def report
    puts "'report' method in module M"
  end
end

class C
  include M
end

class D < C
end

obj = D.new
obj.report

puts __LINE__

# method lookup involves taking the first matching method

module InterestBearing
  def calculate_interest
    puts 'Placeholder, we are in the interest bearing module'
  end
end

class BankAccount
  include InterestBearing
  def calculate_interest
    puts 'Inside the Bank Account class'
    puts 'and we are overring the interest bearing module definition'
  end
end

b = BankAccount.new
b.calculate_interest

puts __LINE__

# you'll see the most recently included module getting called here.

module M
  def report
    puts 'Reporting from M'
  end
end

module N
  def report
    puts 'Reporting from N'
  end
end

class C
  include M
  include N
end

c = C.new
c.report

puts __LINE__

# including a module twice does nothing
# N will be called here

class C
  include M
  include N
  include M
end

c = C.new
c.report

puts __LINE__

# we can use super to go up the method lookup path

module M
  def report
    puts 'inside the M module'
  end
end

class C
  include M
  def report
    puts "'report' inside C class"
    puts 'triggering super...'
    super
    puts 'back inside C class report method'
  end
end

c = C.new
c.report

puts __LINE__

# super makes it easy to have a bike class and a tandem class

class Bicycle
  attr_reader :gears, :wheels, :seats

  def initialize(gears = 1)
    @wheels = 2
    @seats = 1
    @gears = gears
  end
end

class Tandem < Bicycle
  def initialize(gears)
    super
    @seats = 2
  end
end


puts __LINE__

# combining method missing and super can be useful

class Student
  def method_missing(m, *args)
    if m.to_s.starts_with?("grades_for")
      # return their grade
    else
      super
    end
  end
end
