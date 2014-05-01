require "test/unit"
require "rbconfig"
require "../lib/palmade/tapsilog"
require "sqlite3"

class TC_Tapsilog < Test::Unit::TestCase
  
  def setup
    assert_nothing_raised("setup failed") do
      @logger = Palmade::Tapsilog::Logger.new("default", "/tmp/tapsilog.sock", "some_serious_key")
      @db = SQLite3::Database.new "logs.sqlite"
       
      @rubybin = File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"])
    end
  end
  
  def teardown
    ## Nothing really
  end
  
  def test_serve
    @tapsilog_pid = exec("#{@rubybin} ../bin/tapsilog -c ./tapsilog.conf -w ./tapsilog.pid")
    sleep 1
    puts "pid #{@tapsilog_pid}.\n\n"
  end

  def test_no_fail
    assert_nothing_raised( RuntimeError ) { @logger.info("I am logging a message.", {:author => "arif"}) }
  end
  
  def test_srv_alive
    ## todo
  end

  ## add more test

end
