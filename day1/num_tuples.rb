class NumberTuples
  def initialize(file_path)
    @nums = Hash.new(0)
    File.open(__dir__ + file_path).each do |num|
      @nums[num.to_i] = @nums[num.to_i] + 1
    end
  end

  def find_pairs(target)
    @nums.each do |num, occ|
      if @nums.key?(target - num)
        other = target - num
        return num * (target - num) if (num != other) || ((num == other) && occ > 1)
      end
    end
    return -1
  end

  # TODO Fix the duplicate issues in this logic
  def find_triplets(target)
    @nums.each do |num, occ|
      pair = find_pairs(target - num)
      return num * pair if pair != -1
    end
  end
end
