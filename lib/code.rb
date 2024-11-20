# frozen_string_literal: true

class Code
  COMP = {
    '0' => '0101010', '1' => '0111111', '-1' => '0111010', 'D' => '0001100',
    'A' => '0110000', '!D' => '0001101', '!A' => '0110001', '-D' => '0001111',
    '-A' => '0110011', 'D+1' => '0011111', 'A+1' => '0110111', 'D-1' => '0001110',
    'A-1' => '0110010', 'D+A' => '0000010', 'D-A' => '0010011', 'A-D' => '0000111',
    'D&A' => '0000000', 'D|A' => '0010101', 'M' => '1110000', '!M' => '1110001',
    '-M' => '1110011', 'M+1' => '1110111', 'M-1' => '1110010', 'D+M' => '1000010',
    'D-M' => '1010011', 'M-D' => '1000111', 'D&M' => '1000000', 'D|M' => '1010101'
  }.freeze

  DEST = {
    'null' => '000', 'M' => '001', 'D' => '010', 'MD' => '011',
    'A' => '100', 'AM' => '101', 'AD' => '110', 'AMD' => '111'
  }.freeze

  JUMP = {
    'null' => '000', 'JGT' => '001', 'JEQ' => '010', 'JGE' => '011',
    'JLT' => '100', 'JNE' => '101', 'JLE' => '110', 'JMP' => '111'
  }.freeze

  class << self
    def decode(line, symbol_table)
      a_command?(line) ? parse_a_command(line, symbol_table) : parse_c_command(line)
    end

    private

    def a_command?(line)
      line.start_with?('@')
    end

    def parse_a_command(line, symbol_table)
      address = symbol_table.get_address(line[1..]) || line[1..]
      to_binary(address)
    end

    def parse_c_command(line)
      dest, comp, jump = parse_c_components(line)
      "111#{COMP[comp] || '0000000'}#{DEST[dest] || '000'}#{JUMP[jump] || '000'}"
    end

    def parse_c_components(line)
      match = line.match(/^(?<dest>[^=;]+)?=?(?<comp>[^;]+);?(?<jump>.+)?$/)
      [match[:dest], match[:comp], match[:jump]]
    end

    def to_binary(number)
      number.to_i.to_s(2).rjust(16, '0')
    end
  end
end
