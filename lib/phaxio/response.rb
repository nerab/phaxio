module Phaxio
  class Response
    include ErrorMapper

    def initialize(hash)
      @hash = hash
    end

    def data
      @hash['data']
    end

    def success?
      state
    end

    def state
      @hash['success']
    end

    def message
      @hash['message']
    end

    private

    def error_code
      @hash['error_code']
    end

    def error_type
      @hash['error_type']
    end
  end
end
