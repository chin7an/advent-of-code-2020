require 'set'

class Passport
  Height = Struct.new(:val, :unit)

  RULES = {
    'byr' => ->(fld) { fld.match(/^\d{4}$/) && fld.to_i.between?(1920, 2002) },
    'iyr' => ->(fld) { fld.match(/^\d{4}$/) && fld.to_i.between?(2010, 2020) },
    'eyr' => ->(fld) { fld.match(/^\d{4}$/) && fld.to_i.between?(2020, 2030) },
    'hgt' => lambda { |fld|
      hgt = fld.match(/^(\d{2,3})(cm|in)$/) { |m| Height.new(*m.captures) }
      case hgt&.unit
      when 'cm'
        hgt.val.to_i.between?(150, 193)
      when 'in'
        hgt.val.to_i.between?(59, 76)
      else
        false
      end
    },
    'hcl' => ->(fld) { fld.match(/^#[0-9a-f]{6}$/) },
    'ecl' => ->(fld) { fld.match(/^amb|blu|brn|gry|grn|hzl|oth$/) },
    'pid' => ->(fld) { fld.match(/^\d{9}$/) }
  }.freeze

  def initialize
    @reqs = Set['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']
  end

  def ingest(line)
    line.strip.split(' ').each do |field|
      @reqs.delete(field.split(':')[0])
    end
  end

  def ingest_valid(line)
    line.strip.split(' ').each do |fld|
      kv = fld.split(':')
      @reqs.delete(kv[0]) if RULES[kv[0]]&.call(kv[1])
    end
  end

  def valid?
    @reqs.empty?
  end
end
