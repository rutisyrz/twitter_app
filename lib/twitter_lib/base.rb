module TwitterLib
  class Base

    def initialize
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = TWITTER["consumer_key"]
        config.consumer_secret     = TWITTER["consumer_secret"]
        config.access_token        = TWITTER["access_token"]
        config.access_token_secret = TWITTER["access_token_secret"]
      end
    end

    def search_feeds(query_str, options={})
      begin
        # Validate query string
        return {error: "Invalid query format", result: []} unless is_valid_query?(query_str)
        feeds = @client.search(query_str, options)
        {result: feeds}
      rescue Twitter::Error::Unauthorized => e
        Rails.logger.error "Error in Twitter::Base search_feeds method - Error: Unauthorized - #{e.message}"
      rescue Exception => e
        Rails.logger.error "Error in Twitter::Base search_feeds method - #{e.message}"
      end
    end

    private

    def is_valid_query?(query_str)
      (query_str.present? && query_str.is_a?(String))
    end

  end
end