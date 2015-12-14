module Phaxio
  class Fax
    MissingRecipient = Class.new(StandardError) do
      def initialize
        super('At least one recipient is required.')
      end
    end

    MissingFile = Class.new(StandardError) do
      def initialize
        super('At least one file is required.')
      end
    end

    attr_reader :to, :files

    def initialize(to = nil, file = nil)
      @recipients = Array(to)
      @files = Array(file)
    end

    def add_recipient(recipient)
      @recipients << recipient
    end

    def add_file(*file_names)
      @files.concat(file_names.flatten.map { |file_name| File.new(file_name) })
    end

    def to_h
      result = {}

      @recipients.each.with_index do |to, i|
        result["to[#{i}]"] = to
      end

      @files.each.with_index do |file, i|
        result["filename[#{i}]"] = file
      end

      validate_complete!(result)

      result
    end

    private

    def validate_complete!(hash)
      fail MissingRecipient if hash.select { |k, _| k.start_with?('to') }.empty?
      fail MissingFile if hash.select { |k, _| k.start_with?('filename') }.empty?
    end
  end
end
