# frozen_string_literal: true

require_relative 'code'

class Parser
  def initialize(file, symbol_table)
    @file = file
    @symbol_table = symbol_table
  end

  def run
    lines = preprocess_file
    add_variables(lines)
    decode_lines(lines)
  end

  private

  def preprocess_file
    line_number = 0

    @file.each_with_object([]) do |line, result|
      cleaned = clean(line)
      next if cleaned.empty? || comment?(cleaned)

      if symbol?(cleaned)
        @symbol_table.add_symbol(symbol_name(cleaned), line_number)
      else
        result << cleaned
        line_number += 1
      end
    end
  end

  def add_variables(lines)
    lines.each do |line|
      next unless variable?(line) && !@symbol_table.contains?(line[1..])

      @symbol_table.add_variable(line[1..])
    end
  end

  def decode_lines(lines)
    lines.map { |line| Code.decode(line, @symbol_table) }
  end

  def symbol?(line)
    line.match(/^\(.*\)$/)
  end

  def clean(line)
    line.gsub(%r{\s+|//.*}, '').strip
  end

  def comment?(line)
    line.start_with?('//')
  end

  def symbol_name(line)
    line[1..-2]
  end

  def variable?(line)
    line.match(/^@[A-Za-z]+$/)
  end
end
