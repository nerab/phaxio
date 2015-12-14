require_relative '../test_helper'

class TestResponseMapper < MiniTest::Test
  include FakeWebHelpers

  def setup
    @response_mapper = Phaxio::ResponseMapper.new
  end

  def teardown
    clean_registry
  end

  def test_send_success
    register('https://api.phaxio.com/v1/send', 'test/support/responses/send_success.json')

    response = @response_mapper.map(Phaxio.send_fax({}))

    assert(response)
    assert(response.success?)
    refute(response.error)
  end

  def test_send_document_conversion_error
    register(
      'https://api.phaxio.com/v1/send',
      'test/support/responses/send_document_conversion_error.json'
    )

    response = @response_mapper.map(Phaxio.send_fax({}))

    assert(response)
    refute(response.success?)

    error = response.error
    assert(error)
    assert(error.is_a?(StandardError))
    assert_equal('User simulated Document Conversion Error', error.message)
  end
end
