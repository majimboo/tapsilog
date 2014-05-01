# require 'rubygems'
require '../lib/palmade/tapsilog'
require 'test/unit'

class TestTapsilog < Test::Unit::TestCase
  
  def setup
    assert_nothing_raised("setup failed") do
      @logger = Palmade::Tapsilog::Logger.new('default', '/tmp/tapsilog.sock', 'some_serious_key')
    end
  end
  
  def teardown
    ## Nothing really
  end
  
  def test_no_fail
    assert_nothing_raised( RuntimeError ) { @logger.info("I am logging a message.", {:author => "arif"}) }
  end
  
  def test_srv_alive
    ## todo
  end

  ## add more test

  protected 
  
  def db
    if @db.nil?
      @db = SQLite3::Database.new "logs.sqlite"
    end
    @db
  end  
  
end
