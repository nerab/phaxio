require_relative '../test_helper'
require 'pathname'

class TestFax < MiniTest::Test
  include FixtureHelpers

  def setup
    @fax = Phaxio::Fax.new
  end

  def test_single_receiver
    @fax.add_recipient('+1234567890')
    @fax.add_file(fixture('responses/test.pdf'))

    hash = @fax.to_h
    assert(hash)
    refute_empty(hash)
    assert_equal('+1234567890', hash['to[0]'])
    assert(hash['filename[0]'])
  end

  def test_no_receiver
    assert_raises Phaxio::Fax::MissingRecipient do
      @fax.to_h
    end
  end

  def test_no_file
    @fax.add_recipient('+1234567890')
    assert_raises Phaxio::Fax::MissingFile do
      @fax.to_h
    end
  end

  def test_multiple_receivers
    @fax.add_recipient('+1234567890')
    @fax.add_recipient('+9876543210')
    @fax.add_file(fixture('responses/test.pdf'))

    hash = @fax.to_h
    assert(hash)
    refute_empty(hash)
    assert_equal('+1234567890', hash['to[0]'])
    assert_equal('+9876543210', hash['to[1]'])
    assert(hash['filename[0]'])
  end

  def test_multiple_files
    @fax.add_recipient('+1234567890')
    @fax.add_file(fixture('responses/test.pdf'))
    @fax.add_file(fixture('responses/test.pdf'))

    hash = @fax.to_h
    assert(hash)
    refute_empty(hash)
    assert_equal('+1234567890', hash['to[0]'])
    assert(hash['filename[0]'])
    assert(hash['filename[1]'])
  end

  def test_multiple_file_array
    @fax.add_recipient('+1234567890')
    @fax.add_file([fixture('responses/test.pdf'), fixture('responses/test.pdf')])

    hash = @fax.to_h
    assert(hash)
    refute_empty(hash)
    assert_equal('+1234567890', hash['to[0]'])
    assert(hash['filename[0]'])
    assert(hash['filename[1]'])
  end
end
