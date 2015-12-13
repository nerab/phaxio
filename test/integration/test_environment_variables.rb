require 'test_helper'
require 'shellwords'

module PhaxioTests
  class TestEnvironmentVariables < Minitest::Test
    BIN_PHAXIO = 'bin/phaxio'

    def assert_command(cmd = nil, expected_status = 0, *args)
      out, err, status = Open3.capture3("#{BIN_PHAXIO} #{cmd} #{Shellwords.join(args)}")
      assert_equal(expected_status, status.exitstatus, "Expected exit status to be #{expected_status}, but it was #{status.exitstatus}. STDERR is: '#{err}'")
      assert_empty(err)
      out
    end

    def refute_command(cmd = nil, expected_status = 1, *args)
      out, err, status = Open3.capture3("#{BIN_PHAXIO} #{cmd} #{Shellwords.join(args)}")
      assert_equal(expected_status, status.exitstatus, "Expected exit status to be #{expected_status}, but it was #{status.exitstatus}")
      [out, err]
    end

    def setup
      ENV.delete('PHAXIO_KEY')
      ENV.delete('PHAXIO_SECRET')
      refute ENV['PHAXIO_KEY']
      refute ENV['PHAXIO_SECRET']
    end

    def test_no_api_key
      refute_command('status', 1, '12345')
    end

    def test_no_api_secret
      ENV['PHAXIO_KEY'] = '0815'
      refute_command('status', 1, '12345')
    end

    def test_both_present_but_illegal
      ENV['PHAXIO_KEY'] = '0815'
      ENV['PHAXIO_SECRET'] = '23'
      refute_command('status', 1, '12345')
    end
  end
end
