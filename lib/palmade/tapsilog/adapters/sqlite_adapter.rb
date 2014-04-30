# I'm not sure if I should include it directly to the adapter 
# or is there a better way of doing this?
require "sqlite3"

module Palmade::Tapsilog::Adapters
  class SqliteAdapter < BaseAdapter

    def initialize(config)
      super(config)
    end

    def write(log_message)
      service = log_message[1]
      instance_key = log_message[2]
      severity = log_message[3]
      message = log_message[4]
      tags = log_message[5]

      db.execute("SELECT 1")
    end

    # Closes this database.
    def close
      db.close
    end

    protected

    def db
      if @db.nil?

        @db = SQLite3::Database.new "#{@config[:database]}.sqlite"

        # first create table if it does not exist
        db.execute "CREATE TABLE IF NOT EXISTS #{@config[:table]} ( service varchar(30), message varchar(30) );"

        # possible log format based on file and proxy adapter
        # no test was done to see the actual result of file logging
        # service|instance_key|severity|message|tags

        # proxy adapter code 

        # if @config[:socket]
        #   target = @config[:socket]
        # else
        #   target = "#{@config[:host]}:#{@config[:port]}"
        # end

        # Trying to apply something I just learned while studying ruby last night
        # Short-Circuit Evaluation

        # target = @config[:socket] || "#{@config[:host]}:#{@config[:port]}"
      end
      @db
    end

  end
end
