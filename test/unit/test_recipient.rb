require_relative '../test_helper'

class TestRecipient < MiniTest::Test
  def test_values
    recipient = Phaxio::Recipient.new
    recipient.number = '4141234567'
    recipient.status = 'success'
    recipient.completed_at = Time.at(1_293_911_100)

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

  def test_error
    recipient = Phaxio::Recipient.new
    recipient.number = '4141234567'
    recipient.status = 'success'
    recipient.completed_at = Time.at(1_293_911_100)
    recipient.error = Phaxio::Errors::DocumentConversionError.new('User simulated Document Conversion Error')

    assert(recipient)
    error = recipient.error

    assert(error)
    assert_equal('User simulated Document Conversion Error', error.message)
  end
end
