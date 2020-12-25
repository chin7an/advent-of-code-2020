class Toboggan
  Point = Struct.new(:x, :y)

  def initialize(map_file, slope_x, slope_y)
    @map = File.open(__dir__ + map_file).map do |line|
      line.chomp.split(//)
    end
    @slope_x = slope_x
    @slope_y = slope_y
  end

  def change_slope(x, y)
    @slope_x = x
    @slope_y = y
  end

  def count_trees
    map_width = @map[0].length
    trees = 0
    tobo = Point.new(0, 0)
    while tobo.y < @map.length
      trees += 1 if (@map[tobo.y][tobo.x]).eql?('#')
      move(tobo, map_width)
    end
    trees
  end

  private

  def move(tobo, map_width)
    tobo.x = (tobo.x + @slope_x) % map_width
    tobo.y = (tobo.y + @slope_y)
    tobo
  end

end