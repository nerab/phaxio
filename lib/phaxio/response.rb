module Phaxio
  class Response
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

    def error
      return nil unless @hash['error_type']
      resolve_class(@hash['error_type']).new(@hash['error_code'])
    end

    private

    def resolve_class(name)
      Phaxio::Errors.const_get(name.sub(/./, &:upcase))
    end
  end
end
