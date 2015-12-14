module Phaxio
  class Status
    FINAL = %w(success failure partialsuccess)

    attr_accessor :provider
    attr_reader :id

    def initialize(id)
      fail ArgumentError.new('Missing fax id') if id.nil?
      @id = id
    end

    def delivered?
      'success' == state
    end

    def state
      fax['status']
    end

    def page_count
      fax['num_pages']
    end

    def cost
      fax['cost']
    end

    def direction
      fax['direction']
    end

    def requested_at
      Time.at(fax['requested_at'])
    end

    def completed_at
      Time.at(fax['completed_at'])
    end

    def test?
      fax['is_test']
    end

    def recipients
      recipient_mapper = RecipientMapper.new
      fax['recipients'].map { |recipient| recipient_mapper.map(recipient) }
    end

    def raw
      provider.get_fax_status(id: @id)
    end

    def to_s
      "#{state} as #{fax['id']}"
    end

    #
    # returns true if the status is final, i.e. it is not expected to change
    # even after subsequent calls to this method.
    #
    def final?
      return false if @response.nil?
      FINAL.include?(@response.data['status'])
    end

    private

    def fax
      response.data
    end

    def response
      if @response && final?
        @response
      else
        @response = Response.new(raw)
      end
    end

    def provider
      @provider || Phaxio
    end
  end
end
