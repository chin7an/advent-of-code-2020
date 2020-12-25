def find_highest_seat(boarding_passes)
  get_sorted_seats(boarding_passes).max
end

def find_missing_seat(boarding_passes)
  seats = get_sorted_seats(boarding_passes)
  find_missing_binary_partition(0, (seats.length - 1), seats)
end

def get_sorted_seats(boarding_passes)
  File.open(__dir__ + boarding_passes).map do |seat|
    rows, cols = seat.match(/^([BF]{7})([LR]{3})$/).captures
    row = traverse_binary_partition([0, 127], ['F', 'B'], rows)
    col = traverse_binary_partition([0, 7], ['L', 'R'], cols)
    (row * 8) + col
  end.sort
end

def find_missing_binary_partition(left, right, seats)
  return nil if left == right
  return (seats[left] + 1) if (left + 1) == right

  mid = (left + right) / 2
  if ((seats[mid] - seats[left]) - (mid - left)).zero?
    # go right
    find_missing_binary_partition(mid, right, seats)
  else
    # go left
    find_missing_binary_partition(left, mid, seats)
  end
end

def traverse_binary_partition(bounds, directives, partition)
  low, high = bounds
  lower, upper = directives

  partition.chars.each do |dir|
    case dir
    when lower
      high = (low + high) / 2
    when upper
      low = ((low + high) / 2) + 1
    end
  end
  (low == high) ? low : -1
end

puts find_highest_seat('/day_5_1.txt')
puts find_missing_seat('/day_5_1.txt')