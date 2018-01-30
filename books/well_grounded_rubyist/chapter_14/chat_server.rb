require 'socket'

def welcome(chatter)
  chatter.puts 'Sit down. Enter your name:'
  chatter.readline.chomp
end

def broadcast(message, chatters)
  chatters.each do |chatter|
    chatter.puts message
  end
end

s = TCPServer.new(3939)
chatters = []

while(chatter = s.accept)
  Thread.new(chatter) do |c|
    name = welcome(chatter)
    broadcast("#{name} has joined", chatters)
    chatters < chatter
    begin
      loop do
        line = c.readline
        broadcast("#{name}: #{line}", line)
      end
    rescue EOFError
      c.close
      chatters.delete(c)
      broadcast("#{chatter} has left", chatters)
    end
  end
end
