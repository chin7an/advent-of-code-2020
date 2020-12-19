require 'set'

Content = Struct.new(:quantity, :color)

RULE_PATTERN = /(.*) bags contain (.*)./.freeze
CONTENT_PATTERN = /(\d+) (.*) bags?/.freeze

def parse_bag_rules(rules_file)
  rules = Hash.new { |hash, key| hash[key] = [] }
  File.open(__dir__ + rules_file).each do |rule|
    container_color, allowed = rule.match(RULE_PATTERN).captures
    next if allowed =~ /no other bags/

    allowed.split(',').each do |content|
      rules[container_color] << Content.new(*content.match(CONTENT_PATTERN).captures)
    end
  end
  rules
end

def get_bags_contained(rules_hash, color)
  return 0 unless rules_hash.key?(color)

  bags_contained = 0
  rules_hash[color].each do |content|
    quantity = content.quantity.to_i
    content_color = content.color
    bags_contained += (quantity + (quantity * get_bags_contained(rules_hash, content_color)))
  end

  bags_contained
end

puts get_bags_contained(parse_bag_rules('/day_7.txt'), 'shiny gold')
#puts get_bags_contained(parse_bag_rules('/test_1.txt'), 'shiny gold')
#puts get_bags_contained(parse_bag_rules('/test_2.txt'), 'shiny gold')
