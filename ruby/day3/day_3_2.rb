require_relative 'toboggan'

tobo = Toboggan.new('/day_3_1.txt', 1, 1)
res = tobo.count_trees

tobo.change_slope(3, 1)
res *= tobo.count_trees

tobo.change_slope(5, 1)
res *= tobo.count_trees

tobo.change_slope(7, 1)
res *= tobo.count_trees

tobo.change_slope(1, 2)
res *= tobo.count_trees

puts res
