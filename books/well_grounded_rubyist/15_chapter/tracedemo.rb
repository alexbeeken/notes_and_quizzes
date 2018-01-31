require './stack_trace'

def x
  y
end

def y
  z
end

def z
  stack = CallerTools::Stack.new
  puts stack.report
end

x
