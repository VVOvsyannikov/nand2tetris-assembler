# frozen_string_literal: true

require_relative 'lib/parser'
require_relative 'lib/symbol_table'

class Main
  class << self
    def run
      file_name = ARGV[0]
      validate_file_name(file_name)
      process_file(file_name)
    end

    private

    def validate_file_name(file_name)
      return if file_name

      puts 'Error: Please provide a file name.'
      exit(1)
    end

    def process_file(file_name)
      input_path = "files/#{file_name}"
      output_path = "files/#{file_name.gsub('.asm', '.hack')}"

      File.open(input_path, 'r') do |file|
        symbol_table = SymbolTable.new
        result = Parser.new(file, symbol_table).run

        File.open(output_path, 'w') do |putput_file|
          result.each { |line| putput_file.puts(line) }
        end
      end
    end
  end
end

Main.run
