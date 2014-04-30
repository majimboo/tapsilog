# I'm not sure if I should include it directly to the adapter 
# or is there a better way of doing this?
require "sqlite3"
# methods found @ http://sqlite-ruby.rubyforge.org/sqlite3/classes/SQLite3/Database.html

module Palmade::Tapsilog::Adapters
  class SqliteAdapter < BaseAdapter

    def initialize(config)
      super(config)
    end

    def write(log_message)
      service      = log_message[1]
      instance_key = log_message[2]
      severity     = log_message[3]
      message      = log_message[4]
      tags         = Palmade::Tapsilog::Utils.hash_to_query_string(log_message[5])

      # make default values incase user forgets to specify additional configurations
      # to be refactored as it looks messy to have this here and below
      table    = @config[:table] || 'logtable'

      # insert logs here
      db.execute("INSERT INTO #{table} (`service`, `instance_key`, `severity`, `message`, `tags`) VALUES (?, ?, ?, ?, ?)", [service, instance_key, severity, message, tags])
    end

    # Closes this database.
    def close
      db.close
    end

    protected

    def db
      if @db.nil?
        # make default values incase user forgets to specify additional configurations
        database = @config[:database] || 'logfile'
        table    = @config[:table] || 'logtable'

        @db = SQLite3::Database.new "#{database}.sqlite"

        # first create table if it does not exist
        @db.execute "CREATE TABLE IF NOT EXISTS #{table} ( service varchar(30), instance_key int, severity varchar(30), message TEXT, tags TEXT );"

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
