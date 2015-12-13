module Phaxio
  module Errors
    DocumentConversionError = Class.new(StandardError)
    LineError = Class.new(StandardError)
    FaxError = Class.new(StandardError)
    FatalError = Class.new(StandardError)
    GeneralError = Class.new(StandardError)
  end
end
