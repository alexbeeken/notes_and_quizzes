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
      answer = STDIN.gets.chomp
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
  if ARGV[0]
    yaml_file_paths << path if path.include?(ARGV[0]) && path =~ /.*\.yaml$/
  else
    yaml_file_paths << path if path =~ /.*\.yaml$/
  end
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
  number = STDIN.gets.chomp.to_i
  topic = yaml_file_paths[number - 1]
end

questions = YAML.load_file(topic)
no_randomize = [ARGV[1], ARGV[0]].include? '--no-random'
order = no_randomize ? questions : questions.shuffle

raise "no questions in the file!" unless questions
incorrect = ask_questions(order)

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
