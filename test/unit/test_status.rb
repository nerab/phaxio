require_relative '../test_helper'

class TestStatus < MiniTest::Test
  def test_send_fax
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
end
