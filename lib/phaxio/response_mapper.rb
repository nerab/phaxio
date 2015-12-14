module Phaxio
  class ResponseMapper
    include ErrorMapper

    def map(attributes)
      Response.new.tap do |recipient|
        %w(success data message).each do |key|
          recipient.send("#{key}=", attributes[key])
        end

        recipient.error = ErrorMapper.error(
          attributes['error_type'],
          attributes['error_code']
        )
      end
    end
  end
end
