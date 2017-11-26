require 'minitest/autorun'
require_relative '/../twitter.rb'

class TestTwitter < Minitest::Test
  
  def test_fav_checker
    assert_equal 