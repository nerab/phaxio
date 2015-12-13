require_relative '../test_helper'

class TestRecipient < MiniTest::Test
  def test_values
    recipient = Phaxio::Recipient.new
    recipient.number = '4141234567'
    recipient.status = 'success'
    recipient.completed_at = 1_293_911_100

    assert(recipient)
    assert_equal('4141234567', recipient.number)
    assert_equal('success', recipient.status)
    assert_equal(Time.at(1_293_911_100), recipient.completed_at)
  end

  def test_from_hash
    recipient = Phaxio::Recipient.from_hash(
      'number' => '4141234567',
      'status' => 'success',
      'completed_at' => 1_293_911_100
    )

    assert(recipient)
    assert_equal('4141234567', recipient.number)
    assert_equal('success', recipient.status)
    assert_equal(Time.at(1_293_911_100), recipient.completed_at)
  end

  def test_no_date
    recipient = Phaxio::Recipient.new
    recipient.number = '4141234567'
    recipient.status = 'success'

    assert(recipient)
    assert(recipient.number)
    assert(recipient.status)
    refute(recipient.completed_at)
  end
end
