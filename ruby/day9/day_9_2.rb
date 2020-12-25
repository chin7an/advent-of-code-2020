PROD_TARGET = 1_212_510_616
TEST_TARGET = 127

def scan_xmas_input(file, target)
  window = 2.times.map { file.gets.to_i }
  sum = window.sum

  until file.eof? || sum.eql?(target)
    next_w = file.gets.to_i
    window << next_w
    sum += next_w
    sum -= window.shift while sum > target
  end

  # sum either equal to target or not
  sum.eql?(target) ? window.min + window.max : -1
ensure
  file.close
end

puts scan_xmas_input(File.open(__dir__ + '/day_9.txt', 'r'), PROD_TARGET)
#puts scan_xmas_input(File.open("#{__dir__}/test.txt", 'r'), TEST_TARGET)
