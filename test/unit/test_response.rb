require_relative '../test_helper'

class TestResponse < MiniTest::Test
  include FakeWebHelpers

  def teardown
    clean_registry
  end

  def test_send_success
    register('https://api.phaxio.com/v1/send', 'test/support/responses/send_success.json')

    response = Phaxio::Response.new(Phaxio.send_fax({}))

    assert(response)
    assert(response.success?)
    refute(response.error)
  end

  def test_send_document_conversion_error
    register(
      'https://api.phaxio.com/v1/send',
      'test/support/responses/send_document_conversion_error.json'
    )

    response = Phaxio::Response.new(Phaxio.send_fax({}))

    assert(response)
    refute(response.success?)

    error = response.error
    assert(error)
    assert(error.is_a?(StandardError))
    assert_equal('User simulated Document Conversion Error', error.message)
  end
end
