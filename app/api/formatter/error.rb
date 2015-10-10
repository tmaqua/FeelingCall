module Formatter
  module Error
    def self.call message, backtrace, options, env
      if message.is_a?(Hash)
        { error: message[:message], code: message[:code] }.to_json
      else
        { error: message }.to_json
      end
    end
  end
end