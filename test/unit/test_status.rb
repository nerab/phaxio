require_relative '../test_helper'

class TestStatus < MiniTest::Test
  include FakeWebHelpers

  def teardown
    clean_registry
  end

  def test_success
    register('https://api.phaxio.com/v1/faxStatus', 'test/support/responses/fax_status_success.json')
    status = Phaxio::Status.new(123_456)

    assert status.delivered?
    assert_equal(123_456, status.id)
    assert_equal(3, status.page_count)
    assert_equal(21, status.cost)
    assert_equal('sent', status.direction)
    assert_equal('success', status.state)
    assert_equal(true, status.test?)
    assert_equal(Time.at(1_293_910_680), status.requested_at)
    assert_equal(Time.at(1_293_911_100), status.completed_at)

    recipients = status.recipients
    assert(recipients)
    assert_equal(1, recipients.size)

    recipient = recipients.first
    assert(recipient)
    assert_equal('4141234567', recipient.number)
    assert_equal('success', recipient.status)
    assert_equal(Time.at(1_293_911_100), recipient.completed_at)
  end

  def test_nil_id
    assert_raises ArgumentError do
      Phaxio::Status.new(nil).status
    end
  end

  def test_send_document_conversion_error
    register(
      'https://api.phaxio.com/v1/faxStatus',
      'test/support/responses/fax_status_document_conversion_error.json'
    )

    status = Phaxio::Status.new(19_324_909)

    refute status.delivered?
    assert_equal(19_324_909, status.id)
    assert_equal(0, status.page_count)
    assert_equal(0, status.cost)
    assert_equal('sent', status.direction)
    assert_equal('failure', status.state)
    assert_equal(true, status.test?)
    assert_equal(Time.at(1_450_014_383), status.requested_at)
    assert_equal(Time.at(1_450_014_386), status.completed_at)

    recipients = status.recipients
    assert(recipients)
    assert_equal(1, recipients.size)

    recipient = recipients.first
    assert(recipient)
    assert_equal('+14141234567', recipient.number)
    assert_equal('failure', recipient.status)
    assert_equal(Time.at(1_450_014_386), recipient.completed_at)
  end

  def test_send_line_error
    register(
      'https://api.phaxio.com/v1/faxStatus',
      'test/support/responses/fax_status_line_error.json'
    )

    status = Phaxio::Status.new(19_325_235)

    refute status.delivered?
    assert_equal(19_325_235, status.id)
    assert_equal(1, status.page_count)
    assert_equal(0, status.cost)
    assert_equal('sent', status.direction)
    assert_equal('failure', status.state)
    assert_equal(true, status.test?)
    assert_equal(Time.at(1_450_018_819), status.requested_at)
    assert_equal(Time.at(1_450_018_824), status.completed_at)

    recipients = status.recipients
    assert(recipients)
    assert_equal(1, recipients.size)

    recipient = recipients.first
    assert(recipient)
    assert_equal('+14141234567', recipient.number)
    assert_equal('failure', recipient.status)
    assert_equal(Time.at(1_450_018_824), recipient.completed_at)
  end
end
