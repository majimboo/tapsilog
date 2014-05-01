require "./test_helper"
require "fileutils"
require "sqlite3"

TAPSILOG_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

describe "Tapsilog" do

  before :all do
    @levels = [ "debug", "info", "warn", "error", "fatal" ]

    FileUtils.rm_rf("/tmp/tapsilog")

    Dir.mkdir("/tmp/tapsilog")
    # $stderr = StringIO.new

    unless @pid = fork
      exec("#{TAPSILOG_ROOT}/bin/tapsilog start -c #{TAPSILOG_ROOT}/test/config/tapsilog.yml")
    end
    sleep 1

    @logger = Palmade::Tapsilog::Logger.new("fatima", "/tmp/tapsilog.sock", "some_serious_key")

    @db = SQLite3::Database.new("/tmp/tapsilog/logs.sqlite")
  end

  it "should write correct pid" do
    # `should be true` instead of `should == true`
    File.exists?("/tmp/tapsilog.pid").should be true
    File.read("/tmp/tapsilog.pid").chomp.should be == @pid.to_s
  end

  it "should accept sqlite adapter logs" do
    @levels.each do |level|
      @logger.log(level, "message")
    end

    # I actually don"t know why we"d have to sleep here, an explanation would be nice :)
    # does this make sure that the above code got completed before proceeding?
    sleep 1

    # check sqlite database here
    count = @db.get_first_value("select count(*) from `histories` where `message` = 'message'")
    count.should be == 4  

    levels = [ "info", "warn", "error", "fatal" ]

    results = @db.execute("select `service` || '|' || `severity` || '|' || `message` from `histories` where `message` = 'message'")

    index = 0
    results.each do |row|
      row.should be == ["fatima|#{levels[index]}|message"]
      index += 1
    end

  end

  it "should accept sqlite adapter logs with a tag" do
    @levels.each do |level|
      @logger.log(level, "message_with_tag", {:foo => "foo"})
    end  
    sleep 1

    # check sqlite database here
    count = @db.get_first_value("select count(*) from `histories`")
    count.should be == 8    

    levels = [ "info", "warn", "error", "fatal" ]

    results = @db.execute("select `service` || '|' || `severity` || '|' || `message` || '|' || `tags` from `histories` where `message` = 'message_with_tag'")

    index = 0
    results.each do |row|
      row.should be == ["fatima|#{levels[index]}|message_with_tag|foo=foo"]
      index += 1
    end
    
  end

  it "should accept sqlite adapter logs with multiple tags" do
    @levels.each do |level|
      @logger.log(level, "message_with_tags", {:foo => "foo", :bar => "bar", :baz => "baz"})
    end  
    sleep 1

    # check sqlite database here
    count = @db.get_first_value("select count(*) from `histories` where `message` = 'message_with_tags'")
    count.should be == 4 

    levels = [ "info", "warn", "error", "fatal" ]

    results = @db.execute("select `service` || '|' || `severity` || '|' || `message` || '|' || `tags` from `histories` where `message` = 'message_with_tags'")

    index = 0
    results.each do |row|
      row.should be == ["fatima|#{levels[index]}|message_with_tags|bar=bar&baz=baz&foo=foo"]
      index += 1
    end

  end

  it "should only log upto level warn if specified" do
    @logger.level = Palmade::Tapsilog::Logger::WARN
    @levels.each do |level|
      @logger.log(level, "no_info_logging")
    end
    sleep 1

    # check sqlite database here
    count = @db.get_first_value("select count(*) from `histories`")
    count.should be == 15  

    # check if `no_info_logging` doesn't have a info severity
    count = @db.get_first_value("select count(*) from `histories` where `message` = 'no_info_logging' and `severity` = 'info'")
    count.should be == 0
  end

  it "should only log upto level debug if specified" do
    @logger.level = Palmade::Tapsilog::Logger::DEBUG
    @levels.each do |level|
      @logger.log(level, "log_debug")
    end
    sleep 1

    # check sqlite database here
    count = @db.get_first_value("select count(*) from `histories`")
    count.should be == 20  

    # check if `no_info_logging` doesn't have a info severity
    count = @db.get_first_value("select count(*) from `histories` where `message` = 'log_debug' and `severity` = 'debug'")
    count.should be == 1
  end

  it "should have created specified database" do
    File.exists?("/tmp/tapsilog/logs.sqlite").should be true
  end

  it "should have created specified table and inserted logs" do
    count = @db.get_first_value("select count(*) from histories")
    count.should be == 20
  end

  # I don"t know how to programatically test this :\?
  it "should rotate the sqlite file everyday" do
    # maybe mock the date?
  end

  it "should cleanup" do
    unless @pid = fork
      exec("#{TAPSILOG_ROOT}/bin/tapsilog stop -c #{TAPSILOG_ROOT}/test/config/tapsilog.yml")
    end

    sleep(1)
    File.exists?("/tmp/tapsilog.pid").should be false
    File.exists?("/tmp/tapsilog.sock").should be false
  end

end
