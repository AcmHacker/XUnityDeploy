#extend string some methods
class String
    def logger
        XUnityDeploy.logger
    end

    def sys_call
        `#{self}`
        logger.error("sys call '#{self}' has error") unless $?.success?
        true if $?.success?
    end

    def sys_call_with_log
        system(self)
        logger.error("sys call '#{self}' has error") unless $?.success?
        true if $?.success?    
    end

    def sys_call_with_result
        results = `#{self}`.chomp
        logger.error("sys call_with_result '#{self}' has error") unless $?.success?
        results if $?.success?
    end
end

