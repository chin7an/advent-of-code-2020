require_relative 'group_answers'

def count_form_answers(answers_file, ingest_all)
  answer_counts = 0
  group_answers = GroupAnswers.new
  File.open(__dir__ + answers_file).each do |line|
    if line.chomp.empty?
      answer_counts += group_answers.get_count
      group_answers = GroupAnswers.new
    else
      if ingest_all
        group_answers.ingest_all(line)
      else
        group_answers.ingest_common(line)
      end
    end
  end
  answer_counts += group_answers.get_count
  answer_counts
end

puts count_form_answers('/day_6_1.txt', true)
puts count_form_answers('/day_6_1.txt', false)