# $LOAD_PATH << '.'
require 'minitest/autorun'
require_relative '../lib/phaxio'
require 'fakeweb'

Phaxio.config do |config|
  config.api_key = '12345678910'
  config.api_secret = '10987654321'
end

module FakeWebHelpers
  def register(uri, fixture_path, content_type = 'application/json')
    FakeWeb.allow_net_connect = false

    FakeWeb.register_uri(
      :post,
      uri,
      body: File.read(fixture_path),
      content_type: content_type
    )
  end

  def clean_registry
    FakeWeb.clean_registry
  end
end
