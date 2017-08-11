module TwitterLib
  class Feed < Base

    DEFAULT_NO_OF_POST_LIMIT = 100
    BATCH_SIZE = 100

    def initialize
      super()
    end

    def export_posts_by_hashtag(hashtag, no_of_posts=DEFAULT_NO_OF_POST_LIMIT)
      begin
        return {success: false, error: "Invalid format of hastag. Sample - \'#ruby\'"} unless is_valid_hashtag?(hashtag)
        # append 'hashtag' with '-rt' to avoid fetching retweets
        @query = (hashtag.include?(" -rb") ? hashtag : "#{hashtag} -rt")
        # Search posts in batch
        result = find_in_batch(no_of_posts, {result_type: 'recent'})
        # Export data into CSV file
        export_data(result)
        {success: true}
      rescue Exception => e
        Rails.logger.error "Error in Twitter::Feed download_posts_by_hashtag method - #{e.message}"
      end
    end

    private

    def is_valid_hashtag?(hashtag)
      (hashtag.present? && hashtag.is_a?(String) && hashtag[0] == "#")
    end

    def find_in_batch(no_of_posts, option_params={})
      feeds_data = []
      search_options = {result_type: option_params[:result_type]}

      while true
        break if no_of_posts <= 0
        search_options[:count] = [no_of_posts, BATCH_SIZE].min

        response = search_feeds(@query, search_options)
        if response[:error].present?
          Rails.logger.error "Error in Twitter::Feed find_in_batch method - #{response[:error]}"
          return
        end
        parsed_data = parse_response(response[:result])
        # Append feeds data of a batch
        feeds_data += parsed_data[:data]

        search_options[:max_id] = parsed_data[:max_id]
        no_of_posts -= BATCH_SIZE
      end
      # Twitter API returns Posts having Id <= max_id that we're passing
      # Which result into having duplicate entry of Last Post & First Post of the batches
      # Hence, return 'uniq' posts
      feeds_data.uniq
    end

    # parse response to fetch required details from posts. i.e, text
    def parse_response(response)
      # response.inject([]) {|res, feed| res << feed.attrs; res}
      response.inject({data: [], max_id: 0}) do |res, feed|
        Rails.logger.info "- Feed - #{[feed.id, feed.user.name, feed.text]}"
        res[:data] << [feed.id, feed.user.name, feed.text]
        res[:max_id]=feed.id
        res
      end
    end

    # Export data to csv
    def export_data(feeds_data)
      file_path = Rails.root.join("log","twitter_log","#{file_name}.csv")
      headers = ["ID, User Name, Tweet Text"]
      ExportCsv.new(file_path, headers, feeds_data).save

      Rails.logger.info "================================================================="
      Rails.logger.info "Please open file - #{file_path} - to view result"
      Rails.logger.info "================================================================="
    end

    # build file name
    def file_name
      # Append timestamp to prevent file from getting overwritten
      "#{@query.parameterize}_#{Time.now.to_i}"
    end
  end
end