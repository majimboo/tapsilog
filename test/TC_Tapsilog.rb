require "test/unit"
require "rbconfig"
require "../lib/palmade/tapsilog"
require "sqlite3"

TAPSILOG_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

class TC_Tapsilog < Test::Unit::TestCase
  
  def setup
    assert_nothing_raised( RuntimeError ) do

      unless @pid = fork
        exec("#{TAPSILOG_ROOT}/bin/tapsilog start -c #{TAPSILOG_ROOT}/test/tapsilog.yml")
      end
      sleep 1

    end
  end
  
  def teardown
    ## Nothing really
  end
  
  def test_srv_alive
    assert_equal(File.exists?("/tmp/tapsilog.pid"), true)
    assert_equal(File.read("/tmp/tapsilog.pid").chomp,  @pid.to_s)
  end

  def test_no_fail
    # assert_nothing_raised( RuntimeError ) { @logger.info("I am logging a message.", {:author => "arif"}) }
  end

  ## add more test

end
