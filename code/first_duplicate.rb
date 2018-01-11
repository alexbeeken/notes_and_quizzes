def firstDuplicate(a)
    find_duplicate(a, get_doubles(a)) || -1
end

def get_doubles(array)
    last = nil
    array.sort.select do |e|
        match = e == last
        last = e
        match
    end
end

def find_duplicate(a, doubles)
  return false if doubles.empty?
  seen = []
  a.detect do |elem|
      return elem if seen.include?(elem)
      seen.push(elem) if doubles.include?(elem)
      false
  end
end

puts firstDuplicate([2, 3, 3, 1, 5, 2])
