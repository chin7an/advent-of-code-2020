require 'set'

def find_jolts_tuple(adapters_set, current_jolt)
  [1, 2, 3]
    .select { |inc| adapters_set.include?(current_jolt + inc) }
    .map { |inc| current_jolt + inc }
end

def build_adapter_chain(adapters_set, chain)
  return true if chain.length.eql?(adapters_set.length)

  curr = chain.last || 0
  find_jolts_tuple(adapters_set, curr).each do |adapter|
    return true if build_adapter_chain(adapters_set, chain.push(adapter))

    chain.pop
  end
  false
end

def calc_chain_differences(adapters_set)
  chain = []
  if build_adapter_chain(adapters_set, chain)
    chain.prepend(0)
    chain.append(chain.last + 3)
    threes = chain.each_cons(2)
                  .map { |diff| diff.last - diff.first }
                  .select { |diff| diff.eql?(3) }
                  .count
    ones = chain.each_cons(2)
                .map { |diff| diff.last - diff.first }
                .select { |diff| diff.eql?(1) }
                .count
    threes * ones
  else
    0
  end
end

#adapters = Set.new(File.open("#{__dir__}/test1.txt").map { |line| line.to_i })
#adapters = Set.new(File.open("#{__dir__}/test2.txt").map { |line| line.to_i })
adapters = Set.new(File.open("#{__dir__}/day_10.txt").map { |line| line.to_i })

puts calc_chain_differences(adapters)
