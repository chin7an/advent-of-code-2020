Rule = Struct.new(:min, :max, :char, :passwd)
PASSWD_RULE = /(\d+)-(\d+) (.+): (.*)/

def valid_passwd?(rule)
  rule.passwd.count(rule.char).between?(rule.min.to_i, rule.max.to_i)
end

def count_valid_passwords(passwds_file)
  valid_passwds = 0
  File.open(__dir__ + passwds_file).each do |rule|
    rule.match(PASSWD_RULE) do |matches|
      r = Rule.new(*matches.captures)
      valid_passwds += 1 if valid_passwd?(r)
    end
  end
  valid_passwds
end

puts count_valid_passwords('/day_2_2.txt')
