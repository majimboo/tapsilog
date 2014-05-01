require "test/unit"
require "rbconfig"
require "../lib/palmade/tapsilog"
require "sqlite3"

TAPSILOG_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

class TC_Tapsilog < Test::Unit::TestCase
  
  def setup
    assert_nothing_raised( "setup failed" ) do
      @levels = [ 'debug', 'info', 'warn', 'error', 'fatal' ]
      
      unless @pid = fork
        exec("#{TAPSILOG_ROOT}/bin/tapsilog start -c #{TAPSILOG_ROOT}/test/config/tapsilog.yml")
      end
      sleep 1
    end
  end
  
  def teardown
    Process.kill "SIGTERM", @pid
    Process.wait @pid
    Dir['t/*'].each {|fn| File.delete(fn)}
  end
  
  def test_srv_alive
    assert_equal(File.exists?("t/tapsilog.pid"), true)
    assert_equal(File.read("t/tapsilog.pid").chomp,  @pid.to_s)
  end

  # def test_logger
  #   logger = Palmade::Tapsilog::Logger.new('fatima', 't/tapsilog.sock', 'some_serious_key')
  #   logger.level = Palmade::Tapsilog::Logger::DEBUG
    
  #   assert_nothing_raised { logger.info('message') }
  # end

  # def test_logger_with_tag
  #   assert_nothing_raised { logger = Palmade::Tapsilog::Logger.new('fatima', 't/tapsilog.sock', 'some_serious_key') }

  #   @levels.each do |level|
  #     assert_nothing_raised { logger.log(level, 'message', :tag => 'tag') }
  #   end
  # end

  # def test_logger_with_tags
  #   assert_nothing_raised { logger = Palmade::Tapsilog::Logger.new('fatima', 't/tapsilog.sock', 'some_serious_key') }

  #   @levels.each do |level|
  #     assert_nothing_raised { logger.log(level, 'message', :tag => 'tag', :taz => 'taz') }
  #   end
  # end

  ## add more test

end
