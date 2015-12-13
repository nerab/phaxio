module Phaxio
  class Response
    def initialize(hash)
      @hash = hash
    end

    def data
      @hash['data']
    end

    def success?
      true == @hash['success']
    end

    def message
      @hash['message']
    end
  end
end
