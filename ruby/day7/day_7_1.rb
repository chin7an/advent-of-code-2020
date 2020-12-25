require 'set'

Container = Struct.new(:quantity, :color)

RULE_PATTERN = /(.*) bags contain (.*)./.freeze
CONTENT_PATTERN = /(\d+) (.*) bags?/.freeze

def parse_bag_rules(rules_file)
  rules = Hash.new { |hash, key| hash[key] = [] }
  File.open(__dir__ + rules_file).each do |rule|
    container_color, allowed = rule.match(RULE_PATTERN).captures
    next if allowed =~ /no other bags/

    allowed.split(',').each do |contents|
      quantity, bag_color = contents.match(CONTENT_PATTERN).captures
      rules[bag_color] << Container.new(quantity, container_color)
    end
  end
  rules
end

def get_valid_bag_colors(rules_hash, color)
  return 0 unless rules_hash.has_key?(color)

  queue = rules_hash[color].map(&:color)
  uniq_colors = Set.new(queue)

  until queue.empty?
    next_colors = rules_hash[queue.pop].map(&:color)
    queue.prepend(*next_colors.reject { |col| uniq_colors.include?(col) })
    uniq_colors.merge(next_colors)
  end

  uniq_colors.length
end

puts get_valid_bag_colors(parse_bag_rules('/day_7.txt'), 'shiny gold')
#puts get_valid_bag_colors(parse_bag_rules('/test_1.txt'), 'shiny gold')
