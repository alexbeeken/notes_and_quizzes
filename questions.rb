require 'yaml'
require 'find'

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

yaml_file_paths = []
Find.find('./') do |path|
  yaml_file_paths << path if path =~ /.*\.yaml$/
end
quiz_names = yaml_file_paths.map { |q| q.split("/").last }

topic = nil
user_message do
  puts 'Interview Practice!'
  puts 'choose topic'
  quiz_names.each_with_index do |topic, index|
    puts "#{index + 1} - #{topic}"
  end
  print "make your selection: "
  topic = yaml_file_paths[gets.to_i - 1]
end

questions = YAML.load_file(topic).shuffle
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
