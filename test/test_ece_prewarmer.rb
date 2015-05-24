require 'minitest_helper'
require 'pp'

class TestEcePrewarmer < Minitest::Test

  def setup
    @host_file = "./test/fixtures/hosts"
    @hosts = Hosts::File.read @host_file
    @opts = { verbose: true }
  end

  def test_that_it_has_a_version_number
    refute_nil ::EcePrewarmer::VERSION
  end

  def test_it_should_add_alias_to_host_file
    EcePrewarmer.add_host_alias('192.168.0.2', 'www.example.com', @host_file)
    @hosts = Hosts::File.read @host_file
    new_host = @hosts.elements.select { |e| e.name == 'www.example.com' }.first
    assert_equal('192.168.0.2', new_host.address)
  end

  def test_it_should_remove_alias_from_host_file
    EcePrewarmer.add_host_alias('192.168.0.2', 'www.example.com', @host_file)
    EcePrewarmer.remove_host_alias('www.example.com', @host_file)
    hosts = Hosts::File.read @host_file
    new_host = hosts.elements.select { |e| e.name == 'www.example.com' }.find
    assert_equal(0, new_host.to_a.size)
  end



end
