

def firstDuplicate(a)
  h = {}
  out = a.detect do |x|
    h[x] ? true : h[x] = true
  end
  out || -1
end

puts firstDuplicate([2, 3, 3, 1, 5, 2])
