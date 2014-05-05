# Tapsilog, an asynchronous logging service

  Tapsilog is a super customized fork of Analogger. Tapsilog allows you to attach tags to log messages so that it can be searched easily.
  Currently, Tapsilog supports files and sqlite as storage backend.

**Supported adapters**
  
  - file - Logs to files, STDOUT or STDERR
  - proxy - Forwards logs to another tapsilog server
  - sqlite - Logs to a sqlite database

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

    socket: /tmp/tapsilog.sock
    pidfile: /tmp/tapsilog.pid
    daemonize: true
    key: some_serious_key

    interval: 1

    levels: [ debug, info, warn, error, fatal ]

    backend:
      adapter: sqlite
      path: /tmp/tapsilog/ # with trailing slash | folder must exist
      database: logs

      services:
        - service: default
          target: histories # table name
        - service: fatima
          target: histories

**Tapsilog Client**

  The tapsilog Logger class quacks like the ruby standard Logger.

**Sample**

    require './lib/palmade/tapsilog'

    logger = Palmade::Tapsilog::Logger.new('default', '/tmp/tapsilog.sock', 'some_serious_key')
    logger.level = Palmade::Tapsilog::Logger::DEBUG 
    logger.info("I am logging a message.", {:author => "arif"})
