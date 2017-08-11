# twitter_app
Twitter API integration

## Enter your Twitter account credentials
- Update file - config/twitter_credential.yml

## Search posts by Hashtag and Export result in CSV file
- Run method in console 
  - ``` TwitterLib::Feed.new.export_posts_by_hashtag("#ruby") ```
  - Pass No of posts you want i.e, 125 - ``` TwitterLib::Feed.new.export_posts_by_hashtag("#ruby", 125) ```
- This will fetch posts and store result in CSV 
  - File name format - ```  "#{query.parameterize}_#{Time.now.to_i}" ```
  - i.e, query = "#ruby", FILE_NAME can be "ruby_TIMESTAMP"
  - FIle Path - /log/twitter_log/FILE_NAME.csv
- Run test cases 
  ```ruby 
  bundle exec rspec ./spec/lib/twitter_feed.rb
  ```
