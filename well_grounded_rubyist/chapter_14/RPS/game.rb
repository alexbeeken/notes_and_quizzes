require 'socket'
require './rps'

s = TCPServer.new(3939)

threads = []

2.times do |n|
  conn = s.accept
  threads << Thread.new(conn) do |c|
    Thread.current[:numer] = n + 1
    Thread.current[:player] = c
    c.puts "Welcome player #{c} ARE YOUUUU READDDYYYYY"
    c.print 'Your move? (rock paper scissors)'
    Thread.current[:move] = c.gets.chomp
    c.puts "Thanks... hang on"
  end
end

a,b = threads
a.join
b.join

rps1, rps2 = Game::RPS.new(a[:move]), Game::RPS.new(b[:move])

winner = rps1.play(rps2)
if winner
  result = winner.move
else
  result = "TIE~!"
end

threads.each do |t|
  t[:player].puts "The winner is #{result}!"
end
