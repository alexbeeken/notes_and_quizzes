require 'pry'

def isCryptSolution(crypt, solution)
  hash = solution.to_h
  nums = crypt.map { |s| convert(s, hash) }
  return false if nums.any? { |n| n[0] == "0" && n.length > 1 }
  nums[0].to_i + nums[1].to_i == nums[2].to_i
end

def convert(word, hash)
  word.split("").map { |c| hash[c] }.join
end



crypt = ["SEND", "MORE", "MONEY"]
solution = [['O', '0'],
            ['M', '1'],
            ['Y', '2'],
            ['E', '5'],
            ['N', '6'],
            ['D', '7'],
            ['R', '8'],
            ['S', '9']]

puts 'should be true'
puts isCryptSolution(crypt, solution)

crypt = ["TEN",
 "TWO",
 "ONE"]
solution = [["O","1"],
 ["T","0"],
 ["W","9"],
 ["E","5"],
 ["N","4"]]

 puts 'should be false'
 puts isCryptSolution(crypt, solution)


 crypt = ["A",
  "A",
  "A"]
 solution = [["O","1"],
  ["T","0"],
  ["W","9"],
  ["E","5"],
  ["N","4"]]

  puts 'should be true'
  puts isCryptSolution(crypt, solution)
