require 'socket'

s = TCPServer.new(3939)

## FIRST ITERATION
# conn = s.accept
# conn.puts 'Heres the date:'
# # can also use Time.now
# # backticks for some reason evals date
# conn.puts `date`
# conn.close

# the above closes the script when the request is filled

# while true
#   conn = s.accept
#   conn.puts 'Heres the date:'
#   # can also use Time.now
#   # backticks for some reason evals date
#   conn.puts `date`
#   conn.close
# end

# this one keeps it open

# while true
#   conn = s.accept
#   conn.puts 'Heres the date:'
#   conn.puts `date`
#   conn.close
# end

# while true
#   conn = s.accept
#   conn.puts 'Whats your name traveler?'
#   name = conn.gets.chomp
#   conn.puts "Hi, #{name}. The time is thusly:"
#   conn.puts `date`
#   conn.close
# end

# above only works with ONE user
# second user sees nothing because
# server is busy

# while true
#   conn = s.accept
#   conn.puts 'Whats your name traveler?'
#   name = conn.gets.chomp
#   conn.puts "Hi, #{name}. The time is thusly:"
#   conn.puts `date`
#   conn.close
# end

# So we need to use threads
# while (conn = s.accept)
#   Thread.new(conn) do |c|
#     c.puts 'Whats your name traveler?'
#     name = c.gets.chomp
#     c.puts "Hi, #{name}. The time is thusly:"
#     c.puts `date`
#     c.close
#   end
# end

# passing the conn to Thread.new(conn) do |c|
# creates a new variable for the thread to use
# instead of having each thread fight over they
# original variable
