module Phaxio
  class Repository
    def send(fax)
      ResponseMapper.new.map(provider.send_fax(fax.to_h))
    end

    def status(id)
      Phaxio::Status.new(id)
    end

    def provider
      @provider || Phaxio
    end
  end
end
