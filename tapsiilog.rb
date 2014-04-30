require './lib/palmade/tapsilog'

logger = Palmade::Tapsilog::Logger.new('default', '/tmp/tapsilog.sock', 'some_serious_key')
logger.level = Palmade::Tapsilog::Logger::DEBUG 
logger.info("I am logging a message.")