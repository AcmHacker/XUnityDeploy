# encoding: utf-8
require 'logger'
module XUnityDeloy
  module Logger
    def logger 
      @logger ||= begin
        # log type
        @logger = ::Logger.new(STDOUT)
       
        # log level
        @logger.level = ::Logger::DEBUG

        @logger.datetime_format = "%Y-%m-%d %H:%M:%S"

        # add log exception 
        def @logger.exception exception, info
            self.error("#{info} and exception trace : \n #{exception.backtrace.join("\n")}")
        end

        @logger
    end
  end
end