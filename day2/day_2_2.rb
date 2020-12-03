Rule = Struct.new(:op1, :op2, :char, :passwd)
PASSWD_RULE = /(\d+)-(\d+) (.+): (.*)/

def valid_passwd?(rule)
  return false if rule.op1.negative? || rule.op2.negative?
  return false if rule.op1 > rule.passwd.length || rule.op2 > rule.passwd.length

  (rule.passwd[rule.op1 - 1].eql?(rule.char)) ^ (rule.passwd[rule.op2 - 1].eql?(rule.char))
end

def count_valid_passwords(passwds_file)
  valid_passwds = 0
  File.open(__dir__ + passwds_file).each do |rule|
    rule.match(PASSWD_RULE) do |matches|
      r = Rule.new(*matches.captures)
      r.op1 = r.op1.to_i
      r.op2 = r.op2.to_i
      valid_passwds += 1 if valid_passwd?(r)
    end
  end
  valid_passwds
end

puts count_valid_passwords('/day_2_2.txt')
