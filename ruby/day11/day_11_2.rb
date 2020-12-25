DIRS = [[-1, -1], [0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0]].freeze
EMPTY = 'L'.freeze
OCCUPIED = '#'.freeze
FLOOR = '.'.freeze

def create_seat_layout(input_file)
  layout = []
  File.open("#{__dir__}/#{input_file}").each do |row|
    layout << row.strip.chars
  end
  layout
end

def within_bounds?(c_x, c_y, max_x, max_y)
  c_x >= 0 && c_y >= 0 &&
    c_x < max_x && c_y < max_y
end

def get_next_state(x_val, y_val, current_layout)
  max_x = current_layout[0].length
  max_y = current_layout.length

  occupied = DIRS.map { |dx, dy| [x_val + dx, y_val + dy] }
                 .select { |x, y| within_bounds?(x, y, max_x, max_y) }
                 .map { |x, y| current_layout[y][x].eql?(OCCUPIED) ? 1 : 0 }
                 .sum

  curr_pos = current_layout[y_val][x_val]
  if curr_pos.eql?(EMPTY) && occupied.zero?
    OCCUPIED
  elsif curr_pos.eql?(OCCUPIED) && occupied > 3
    EMPTY
  else
    curr_pos
  end
end

def get_stable_layout(seats_layout)
  changes = []
  current_layout = seats_layout
  until changes.eql?(current_layout)
    current_layout = changes unless changes.empty?
    changes = []

    current_layout.each_with_index do |row, y_val|
      r_changes = []
      row.each_with_index do |pos, x_val|
        r_changes[x_val] = pos.eql?(FLOOR) ? pos : get_next_state(x_val, y_val, current_layout)
      end
      changes[y_val] = r_changes
    end
  end
  current_layout
end

def count_occupied_seats_stable(seats_layout)
  get_stable_layout(seats_layout)
    .map { |stable_row| stable_row.select { |pos| pos.eql?(OCCUPIED) }.count }
    .sum
end

#seats = create_seat_layout('test.txt')
seats = create_seat_layout("day_11.txt")

puts count_occupied_seats_stable(seats)
