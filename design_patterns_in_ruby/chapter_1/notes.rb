# example of inheritance

class Vehicle
  def start_engine
  end

  def stop_engine
  end
end

class Car < Vehicle
  def sunday_drive
    start_engine
    # drive
    stop_engine
  end
end

# great but now all vehicles must have an engine
# what about bikes?

# Let's do some composition
# let's put engine into its own class

class Engine
  def start
  end
  def stop
  end
end

class Car
  def initialize
    @engine = Engine.new
  end

  def sunday_drive
    @engine.start
    # drive around
    @engine.stop
  end
end

# this offers a lot of advantages
# we can swap out the engine type for another

class Car
  def initialize
    @engine = Engine.new
  end

  def sunday_drive
    @engine.start
    # drive around
    @engine.stop
  end

  def swap_engines
    @engine = GasolineEngine.new
  end

  def start_engine
    @engine.start
  end

  def stop_engine
    @engine.stop
  end
end

# this is called "pass the buck" of delegation
# It gives us a lot of flexibility but
# every method delegated takes up a method definiton
