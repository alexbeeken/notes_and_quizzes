require 'yaml'

TOPICS = %w[ruby rails history rails rails2 ruby ruby2 sql threads proc]

def user_message(&block)
  block.call
  puts "\n\n"
end

def ask_questions(questions)
  incorrect = []
  questions.each do |question|
    user_message do
      puts question['q']
      answer = gets.gsub!("\n", '')
      if answer == question['a'].to_s
        puts 'correct'
      else
        incorrect << question
        puts "incorrect: #{question['a']}"
      end
    end
  end
  incorrect
end

topic = nil
user_message do
  puts 'Interview Practice!'
  puts 'choose topic'
  TOPICS.each_with_index do |topic, index|
    puts "#{index + 1} - #{topic}"
  end
  topic = TOPICS[gets.to_i - 1]
end

questions = YAML.load_file("#{topic}.yaml").shuffle
incorrect = ask_questions(questions)

if incorrect.length > 0
  user_message do
    puts "Try these again!"
    sleep 2
  end
  incorrect = ask_questions(incorrect)
end

correct = questions.length - incorrect.length

user_message do
  puts "You got #{correct} correct out of #{questions.length}"
end
