# Tapsilog, an asynchronous logging service

  Tapsilog is a super customized fork of Analogger. Tapsilog allows you to attach tags to log messages so that it can be searched easily.
  Currently, Tapsilog supports files and mongodb as storage backend.

**Supported adapters**
  
  - file - Logs to files, STDOUT or STDERR
  - mongo - Logs to mongoDB
  - proxy - Forwards logs to another tapsilog server
  - sqlite - Logs to sqlite database

**Gems required for mongoDB support**

  - mongo
  - bson
  - bson_ext

**Gems required for sqlite support**

  - sqlite3

**Installing SQLite-ruby on Ubuntu**

    (sudo) apt-get install libsqlite3-dev
    (sudo) apt-get install ruby-dev

    gem install sqlite3

**Compatibility with analogger**

  Tapsilog is mostly compatible with analogger client. Though there is a known quirk.
  When using the analogger client, text after a colon will be interpreted as a tag.
  Tapsilog URL encodes and decodes messages to circumvent this.
 
## Usage

**Tapsilog Server**
  
  See tapsilog --help for details 


**Sample Proxy Config**

    socket:
      - /tmp/tapsilog_proxy.sock
    daemonize: true
    key: some_serious_key

    syncinterval: 1

    backend:
      adapter: sqlite

      # specify database
      database: logs

      # specify table
      table: history

**Tapsilog Client**

  The tapsilog Logger class quacks like the ruby standard Logger.

**Sample**

    require './lib/palmade/tapsilog'

    logger = Palmade::Tapsilog::Logger.new('default', '/tmp/tapsilog.sock', 'some_serious_key')
    logger.level = Palmade::Tapsilog::Logger::DEBUG # defaults to INFO
    logger.info("I am logging a message.")

