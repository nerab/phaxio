require_relative '../test_helper'

class TestPhaxio < MiniTest::Test
  include FakeWebHelpers

  def setup
    register('https://api.phaxio.com/v1/send', 'test/support/responses/send_success.json')
    register('https://api.phaxio.com/v1/testReceive', 'test/support/responses/test_receive.json')
    register('https://api.phaxio.com/v1/testReceive', 'test/support/responses/test_receive.json')
    register('https://api.phaxio.com/v1/provisionNumber', 'test/support/responses/provision_number.json')
    register('https://api.phaxio.com/v1/releaseNumber', 'test/support/responses/release_number.json')
    register('https://api.phaxio.com/v1/numberList', 'test/support/responses/list_numbers.json')
    register('https://api.phaxio.com/v1/faxFile', 'test/support/responses/test.pdf', 'application/pdf')
    register('https://api.phaxio.com/v1/faxList', 'test/support/responses/list_faxes.json')
    register('https://api.phaxio.com/v1/faxStatus', 'test/support/responses/fax_status_success.json')
    register('https://api.phaxio.com/v1/faxCancel', 'test/support/responses/cancel_success.json')
    register('https://api.phaxio.com/v1/accountStatus', 'test/support/responses/account_status.json')
  end

  def teardown
    clean_registry
  end

  def test_config
    assert_equal '12345678910', Phaxio.api_key
    assert_equal '10987654321', Phaxio.api_secret
  end

  def test_send_fax
    @response = Phaxio.send_fax(to: '0123456789', filename: 'test.pdf')
    assert_equal true, @response['success']
    assert_equal 'Fax queued for sending', @response['message']
    assert_equal 1234, @response['faxId']
  end

  def test_test_receive
    @response = Phaxio.test_receive(filename: 'test_file.pdf')
    assert_equal true, @response['success']
    assert_equal 'Test fax received from 234567890. Calling back now...', @response['message']
  end

  def test_provision_number
    @response = Phaxio.provision_number(area_code: 802)
    assert_equal true, @response['success']
    assert_equal 'Number provisioned successfully!', @response['message']
    assert_equal 'Vermont', @response['data']['state']
  end

  def test_release_number
    @response = Phaxio.release_number(number: '8021112222')
    assert_equal true, @response['success']
    assert_equal 'Number released successfully!', @response['message']
  end

  def test_list_numbers
    @response = Phaxio.list_numbers(area_code: 802)
    assert_equal true, @response['success']
    assert_equal 'Retrieved user phone numbers successfully', @response['message']
  end

  def test_get_fax_file
    @response_pdf = Phaxio.get_fax_file(id: 1234, type: p)
    assert_equal 6725, @response_pdf.size
  end

  def test_list_faxes
    @response = Phaxio.list_faxes(start: 1_293_861_600, end: 1_294_034_400)
    assert_equal true, @response['success']
  end

  def test_get_fax_status
    @response = Phaxio.get_fax_status(id: 123_456)
    assert_equal true, @response['success']
    assert_equal 'Retrieved fax successfully', @response['message']
  end

  def test_cancel_fax
    @response = Phaxio.cancel_fax(id: 123_456)
    assert_equal true, @response['success']
    assert_equal 'Fax canceled successfully.', @response['message']
  end

  def test_get_account_status
    @response = Phaxio.get_account_status
    assert_equal true, @response['success']
    assert_equal 'Account status retrieved successfully', @response['message']
    assert_equal 120, @response['data']['faxes_sent_this_month']
  end
end
