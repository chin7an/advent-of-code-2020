INSTR_PATTERN = /(nop|acc|jmp)\s+(-|\+*)(\d+)/.freeze

Instruction = Struct.new(:opcode, :dir, :val, :processed) do
  def initialize(opcode, dir, val, processed = false)
    super(opcode, dir, val, processed)
  end
end

def read_instructions_tape(tape_file)
  instructions = []
  editable = []
  File.open(__dir__ + tape_file).each_with_index do |instr_line, idx|
    unless (caps = instr_line.match(INSTR_PATTERN)).nil?
      instructions << (inst = Instruction.new(*caps.captures))
      editable << idx if inst.opcode =~ /nop|jmp/
    end
  end
  [instructions, editable]
end

def eval_instr_value(instruction)
  instruction.val.to_i * (instruction.dir.eql?('-') ? -1 : 1)
end

def process_instr(instruction, pc, acc)
  return [-1, acc] if instruction.processed  # Invalid state, infinite loop detected

  case instruction.opcode
  when 'acc'
    acc += eval_instr_value(instruction)
    instruction.processed = true
    [pc + 1, acc]
  when 'jmp'
    instruction.processed = true
    [pc + eval_instr_value(instruction), acc]
  else
    instruction.processed = true
    [pc + 1, acc]
  end
end

def evaluate_instructions(tape)
  pc = 0
  acc = 0

  pc, acc = process_instr(tape[pc], pc, acc) while pc >= 0 && pc < tape.length
  pc <= 0 ? [true, acc] : [false, acc]
end

def reset_tape(tape)
  tape.each do |instr|
    instr.processed = false
  end
end

def toggle_instr(tape, mod_idx)
  old_instr = tape[mod_idx]
  new_opcode = old_instr.opcode.eql?('jmp') ? 'nop' : 'jmp'
  tape[mod_idx] = Instruction.new(new_opcode, old_instr.dir, old_instr.val, old_instr.processed)
end

def modify_tape(tape, bad_instr, mod_idx)
  reset_tape(tape)
  toggle_instr(tape, bad_instr[mod_idx + 1]) if mod_idx != -1
  toggle_instr(tape, bad_instr[mod_idx])
  [tape, mod_idx - 1]
end

def evaluate_or_fix_instructions(tape, possibly_bad_instr)
  acc = 0
  mod_idx = -1
  loop do
    continue, acc = evaluate_instructions(tape)
    break unless continue && mod_idx.abs <= possibly_bad_instr.length

    tape, mod_idx = modify_tape(tape, possibly_bad_instr, mod_idx)
  end
  acc
end

tape, possibly_bad_instr = read_instructions_tape('/day_8.txt')
#tape, possibly_bad_instr = read_instructions_tape('/test.txt')
puts evaluate_or_fix_instructions(tape, possibly_bad_instr)