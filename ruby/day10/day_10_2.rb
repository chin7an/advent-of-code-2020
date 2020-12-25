def find_jolts_tuple(adapter_chain_lengths, current_jolt)
  [1, 2, 3]
    .select { |inc| adapter_chain_lengths.key?(current_jolt + inc) }
    .map { |inc| current_jolt + inc }
end

def build_adapter_chain(adapter_chain_lengths, chain)
  return true if chain.length.eql?(adapter_chain_lengths.length)

  curr = chain.last || 0
  tuple = find_jolts_tuple(adapter_chain_lengths, curr)

  tuple.each do |adapter|
    return true if build_adapter_chain(adapter_chain_lengths, chain.push(adapter))

    chain.pop
  end
  false
end

def calc_chain_possibilities(adapter_chain_lengths)
  chain = []
  if build_adapter_chain(adapter_chain_lengths, chain)
    adapter_chain_lengths[chain.last + 3] = 1
    chain.prepend(0)

    chain.reverse.each do |adapter_jolts|
      length = find_jolts_tuple(adapter_chain_lengths, adapter_jolts)
               .map { |jolts| adapter_chain_lengths[jolts] }
               .sum
      adapter_chain_lengths[adapter_jolts] = length
    end
    adapter_chain_lengths[0]
  else
    0
  end
end

#input_file = 'test1.txt'
#input_file = 'test2.txt'
input_file = 'day_10.txt'

adapters = File.open("#{__dir__}/#{input_file}")
               .collect { |line| [line.to_i, 0] }
adapter_chain_lengths = Hash[adapters]
puts calc_chain_possibilities(adapter_chain_lengths)
