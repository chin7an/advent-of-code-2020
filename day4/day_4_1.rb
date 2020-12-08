require_relative 'passport'

def parse_passports(batch_file)
  valid_passports = 0
  curr_passport = Passport.new
  File.open(__dir__ + batch_file).each do |line|
    if line.chomp.empty?
      valid_passports += 1 if curr_passport.valid?
      curr_passport = Passport.new
    else
      curr_passport.ingest(line)
    end
  end
  valid_passports += 1 if curr_passport.valid?
  valid_passports
end

puts parse_passports('/day_4_1.txt')