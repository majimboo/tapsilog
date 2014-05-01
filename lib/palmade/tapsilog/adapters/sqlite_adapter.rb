require "sqlite3"

module Palmade::Tapsilog::Adapters
  class SqliteAdapter < BaseAdapter

    def write(log_message)
      timestamp, service, instance_key, severity, message, tags = log_message

      unless tags.nil? or tags.empty?
        tags = Palmade::Tapsilog::Utils.hash_to_query_string(tags)
      end

      @table = get_table(service)

      db.execute("INSERT INTO `#{@table}` (`service`, `instance_key`, `severity`, `message`, `tags`) VALUES (?, ?, ?, ?, ?)", [service, instance_key, severity, message, tags])
    end

    # Closes this database.
    def close
      db.close
    end

    protected

    def get_table(service_name)
      service_name = (@services[service_name].nil?) ? 'default' : service_name
      service = @services[service_name]
      service[:target]
    end

    def db
      if @db.nil?
        database = @config[:database] || 'logs'

        @db = SQLite3::Database.new "#{database}.sqlite"

        @db.execute "CREATE TABLE IF NOT EXISTS `#{@table}` ( service varchar(30), instance_key int, severity varchar(30), message text, tags text, created_at timestamp default current_timestamp);"
      end
      @db
    end

  end
end
