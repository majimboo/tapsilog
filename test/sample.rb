require './lib/palmade/tapsilog'

logger = Palmade::Tapsilog::Logger.new('fatima', '/tmp/tapsilog.sock', 'some_serious_key')
logger.level = Palmade::Tapsilog::Logger::DEBUG
logger.info("I am logging a message with tags.", {:author => "arif"})
logger.info("I am logging a message with no tagging.")
logger.info("I am logging a message.", {:author => "arif"})
logger.info("I am logging a message.")
logger.info("I am logging a message with no tagging again.")