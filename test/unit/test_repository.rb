require_relative '../test_helper'

class TestRepository < MiniTest::Test
  include FixtureHelpers
  include FakeWebHelpers

  def setup
    @repository = Phaxio::Repository.new
  end

  def teardown
    clean_registry
  end

  def test_send_success
    register('https://api.phaxio.com/v1/send', 'test/support/responses/send_success.json')

    fax = Phaxio::Fax.new
    fax.add_recipient('+1234567890')
    fax.add_file(fixture('responses/test.pdf'))

    response = @repository.send(fax)

    assert(response)
    assert(response.success?)
    refute(response.error)
  end

  def test_status
    register('https://api.phaxio.com/v1/faxStatus', 'test/support/responses/fax_status_success.json')

    status = @repository.status(123456)
    assert(status)
    assert(status.delivered?)
  end
end
