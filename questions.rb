require 'yaml'

TOPICS = ['ruby', 'rails']

puts 'Interview Practice!'
puts 'choose topic'
TOPICS.each_with_index do |topic, index|
  puts "#{index + 1} - #{topic}"
end
topic = TOPICS[gets.to_i - 1]

questions = YAML.load_file("#{topic}.yaml").shuffle

correct = 0
questions.each do |question|
  puts question['q']
  answer = gets.gsub!("\n", '')
  if answer == question['a'].to_s
    correct += 1
    puts 'correct'
  else
    puts "incorrect: #{question['a']}"
  end
end

puts "You got #{correct} correct out of #{questions.length}"
