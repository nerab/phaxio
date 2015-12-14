module Phaxio
  class RecipientMapper
    include ErrorMapper

    def map(attributes)
      Recipient.new.tap do |recipient|
        recipient.number = attributes['number']
        recipient.status = attributes['status']

        recipient.error = ErrorMapper.error(
          attributes['error_type'],
          attributes['error_code']
        )

        if completed_at = attributes['completed_at']
          recipient.completed_at = Time.at(completed_at)
        end
      end
    end
  end
end
