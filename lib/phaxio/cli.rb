require 'thor'
require 'phaxio'

module Phaxio
  IncompleteConfiguration = Class.new(StandardError) do
    def initialize(key)
      super("The Phaxio API configuration '#{key}' is missing from the environment.")
    end
  end

  class CLI < Thor
    class_option :verbose, type: :boolean

    desc 'send FILE [*FILE]', 'Send one or more files as fax'
    long_desc <<-LONGDESC
    # Fax letter.pdf
    \x5$ phaxio send --to +1-800-dot-com letter.pdf

    # Fax letter.pdf to multiple recipients
    \x5$ phaxio send --to +1-800-dot-com --to 345678900 letter.pdf

    # Fax text given on STDIN
    \x5$ phaxio send --to '+1 800-dot-com' --to 345678900 letter.pdf

    LONGDESC
    option :to, desc: 'Receiver(s) of the fax'
    def send(*files)
      configure!

      fax = { to: options[:to] }

      files.each.with_index do |file, i|
        fax["filename[#{i}]"] = File.new(file)
      end

      response = Response.new(Phaxio.send_fax(fax))

      if response.success?
        puts Phaxio::Status.new(response.data['faxId'])
      else
        fail response.message
      end
    end

    desc 'status ID', 'Show the status of a fax with the given ID'
    option :continue, desc: 'Keep polling until status is final'
    def status(id)
      configure!
      status = Phaxio::Status.new(id)

      STDERR.puts JSON.pretty_generate(status.raw) if options[:verbose]
      puts status

      return unless options[:continue]

      until status.final?
        puts status
        sleep 1
      end
    end

    private

    def configure!
      Phaxio.config do |config|
        config.api_key = config!('PHAXIO_KEY')
        config.api_secret = config!('PHAXIO_SECRET')
      end
    end

    def config!(key)
      fail IncompleteConfiguration.new(key) if ENV[key].nil? || ENV[key].empty?
      ENV.fetch(key)
    end
  end
end
