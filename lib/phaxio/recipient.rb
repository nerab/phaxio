module Phaxio
  Recipient = Struct.new(:number, :status, :completed_at) do
    def self.from_hash(recipient)
      # adapted from http://stackoverflow.com/a/26131816
      new(*recipient.values_at(*Recipient.members.map(&:to_s)))
    end

    def completed_at
      value = self['completed_at']
      value.nil? ? nil : Time.at(value)
    end
  end
end
