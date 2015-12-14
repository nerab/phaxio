module Phaxio
  module ErrorMapper
    def error
      ErrorMapper.error(error_type, error_code)
    end

    def self.error(type, code)
      return nil unless type
      resolve_error_class(type).new(code)
    end

    private

    def self.resolve_error_class(name)
      Phaxio::Errors.const_get(name.sub(/./, &:upcase))
    end
  end

  module Errors
    DocumentConversionError = Class.new(StandardError)
    LineError = Class.new(StandardError)
    FaxError = Class.new(StandardError)
    FatalError = Class.new(StandardError)
    GeneralError = Class.new(StandardError)
  end
end
