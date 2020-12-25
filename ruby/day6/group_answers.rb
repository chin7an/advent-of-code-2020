require 'set'

class GroupAnswers
  def ingest_all(line)
    @ans ||= Set.new
    @ans.merge(line.downcase.chomp.chars)
  end

  def ingest_common(line)
    if @ans.nil?
      ingest_all(line)
    else
      @ans &= line.downcase.chomp.chars
    end
  end

  def get_count
    @ans.length
  end
end