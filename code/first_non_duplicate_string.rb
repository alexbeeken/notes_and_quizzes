def firstNotRepeatingCharacter(s)
    h = {}
    s.split("").each do |c|
      h[c] ? h[c] += 1 : h[c] = 1
    end
    out = h.detect { |k, v| v == 1 }
    out ? out[0] : '_'
end

# def firstNotRepeatingCharacter(s)
#     s = s.split("").sort
#     idx = (1..(s.length - 1)).detect { |i| s[i - 1] != s[i] && s[i] != s[i + 1] }
#     return s[idx] if idx
#     '_'
# end

# def firstNotRepeatingCharacter(s)
#     s.length.times do |i|
#       return s[i] unless s.slice(i+1,s.length)[s[i]]
#     end
# end

puts firstNotRepeatingCharacter("z")
puts firstNotRepeatingCharacter("abcdefgfedcba")
