module Phaxio
  Response = Struct.new(:success, :data, :message, :error) do
    def success?
      success
    end
  end
end
