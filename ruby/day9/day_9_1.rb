require 'set'

def readlines_ints(file, num)
  num.times.each_with_object([]) do |_, acc|
    begin
      acc << file.readline.to_i
    rescue EOFError
      break acc
    end
  end
end

def has_twosum_target(preamble, target)
  mem = Set.new
  preamble.each { |num| mem.include?(target - num) ? (return true) : mem << num }
  false
end

def scan_xmas_input(file, preamble_size)
  preamble = readlines_ints(file, preamble_size)
  target = readlines_ints(file, 1).first

  while has_twosum_target(preamble, target)
    preamble.shift
    preamble << target
    break if (target = readlines_ints(file, 1).first).nil?
  end
  file.close
  target
end

#puts scan_xmas_input(File.open(__dir__ + '/test.txt', 'r'), 5)
puts scan_xmas_input(File.open(__dir__ + '/day_9.txt', 'r'), 25)
