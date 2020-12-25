INSTR_PATTERN = /(nop|acc|jmp)\s+(-|\+*)(\d+)/.freeze
$accum = 0

Instruction = Struct.new(:opcode, :dir, :val, :processed) do
  def initialize(opcode, dir, val, processed = false)
    super(opcode, dir, val, processed)
  end
end

def read_instructions_tape(tape_file)
  instructions = []
  File.open(__dir__ + tape_file).each do |instr_line|
    unless (caps = instr_line.match(INSTR_PATTERN)).nil?
      instructions << Instruction.new(*caps.captures)
    end
  end
  instructions
end

def eval_instr_value(instruction)
  instruction.val.to_i * (instruction.dir.eql?('-') ? -1 : 1)
end

def process_instr(instruction, pc)
  return -1 if instruction.processed  # Invalid state, infinite loop detected

  case instruction.opcode
  when 'acc'
    $accum += eval_instr_value(instruction)
    instruction.processed = true
    pc + 1
  when 'jmp'
    instruction.processed = true
    pc + eval_instr_value(instruction)
  else
    instruction.processed = true
    pc + 1
  end
end

def evaluate_instructions(tape)
  pc = 0
  pc = process_instr(tape[pc], pc) while pc >= 0 && pc < tape.length
end

#tape = read_instructions_tape('/day_8.txt')
tape = read_instructions_tape('/test.txt')
evaluate_instructions(tape)
puts $accum
