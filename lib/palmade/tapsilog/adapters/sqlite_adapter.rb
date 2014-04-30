# I'm not sure if I should include it directly to the adapter 
# or is there a better way of doing this?
require "sqlite3"

module Palmade::Tapsilog::Adapters
  class SQLiteAdapter < BaseAdapter

    def initialize(config)
      super(config)
    end

    def write(log_message)
      service = log_message[1]
      instance_key = log_message[2]
      severity = log_message[3]
      message = log_message[4]
      tags = log_message[5]

      db.log(service, instance_key, severity, message, tags)
    end

    def flush
      db.flush
    end

    def close
      db.close
    end

    protected

    def db
      if @db.nil?
        # if @config[:socket]
        #   target = @config[:socket]
        # else
        #   target = "#{@config[:host]}:#{@config[:port]}"
        # end

        # Trying to apply something I just learned while studying ruby last night
        # Short-Circuit Evaluation
        #target = @config[:socket] || "#{@config[:host]}:#{@config[:port]}"

        @db = SQLite3::Database.new "test.db"
      end
      @db
    end

  end
end
