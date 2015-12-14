require_relative '../test_helper'

class TestRecipientMapper < MiniTest::Test
  def setup
    @mapper = Phaxio::RecipientMapper.new
  end

  def test_success
    recipient = @mapper.map(
      'number' => '4141234567',
      'status' => 'success',
      'completed_at' => 1_293_911_100,
    )

    assert(recipient)
    assert_equal('4141234567', recipient.number)
    assert_equal('success', recipient.status)
    assert_equal(Time.at(1_293_911_100), recipient.completed_at)
    refute(recipient.error)
  end

  def test_documentConversionError
    recipient = @mapper.map(
      'number' => '4141234567',
      'status' => 'success',
      'completed_at' => 1_293_911_100,
      'error_code' => 'User simulated Document Conversion Error',
      'error_type' => 'documentConversionError'
    )

    assert(recipient)
    error = recipient.error

    assert(error)
    assert(error.is_a?(StandardError))
    assert_equal('User simulated Document Conversion Error', error.message)
  end

  def test_line_error
    recipient = @mapper.map(
      'number' => '4141234567',
      'status' => 'success',
      'completed_at' => 1_293_911_100,
      'error_code' => 'User requested simulated lineError',
      'error_type' => 'lineError'
    )

    assert(recipient)
    error = recipient.error

    assert(error)
    assert(error.is_a?(StandardError))
    assert_equal('User requested simulated lineError', error.message)
  end

  def test_fax_error
    recipient = @mapper.map(
      'number' => '4141234567',
      'status' => 'success',
      'completed_at' => 1_293_911_100,
      'error_code' => 'User requested simulated faxError',
      'error_type' => 'faxError'
    )

    assert(recipient)
    error = recipient.error

    assert(error)
    assert(error.is_a?(StandardError))
    assert_equal('User requested simulated faxError', error.message)
  end

  def test_fatal_error
    recipient = @mapper.map(
      'number' => '4141234567',
      'status' => 'success',
      'completed_at' => 1_293_911_100,
      'error_code' => 'User requested simulated fatalError',
      'error_type' => 'fatalError'
    )

    assert(recipient)
    error = recipient.error

    assert(error)
    assert(error.is_a?(StandardError))
    assert_equal('User requested simulated fatalError', error.message)
  end

  def test_general_error
    recipient = @mapper.map(
      'number' => '4141234567',
      'status' => 'success',
      'completed_at' => 1_293_911_100,
      'error_code' => 'General error.  Contact Phaxio support.',
      'error_type' => 'generalError'
    )

    assert(recipient)
    error = recipient.error

    assert(error)
    assert(error.is_a?(StandardError))
    assert_equal('General error.  Contact Phaxio support.', error.message)
  end
end
