require 'rails_helper'
require 'spec_helper'
require "#{Rails.root}/lib/twitter_lib/feed.rb"

describe TwitterLib::Feed do
  describe '#export_posts_by_hashtag' do

    context "Given VALID hashtag value" do
      it "returns true" do
        result = TwitterLib::Feed.new.export_posts_by_hashtag("#ruby")
        expect(result[:success]).to eq (true)
      end

      it "exports data in csv file" do
        dir = Rails.root.join("log","twitter_log")
        old_file_count = Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) }

        TwitterLib::Feed.new.export_posts_by_hashtag("#ruby")

        new_file_count = Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) }
        expect(new_file_count).to eq (old_file_count+1)
      end
    end

    context "Given INVALID hashtag value" do
      it "returns false and error for BLANK value" do
        result = TwitterLib::Feed.new.export_posts_by_hashtag('')
        expect(result[:success]).to eq (false)
        expect(result[:error]).to eq ("Invalid format of hastag. Sample - '#ruby'")
      end

      it "returns false and error for NIL value" do
        result = TwitterLib::Feed.new.export_posts_by_hashtag(nil)
        expect(result[:success]).to eq (false)
        expect(result[:error]).to eq ("Invalid format of hastag. Sample - '#ruby'")
      end

      it "returns false and error for NON-STRING value" do
        result = TwitterLib::Feed.new.export_posts_by_hashtag(123)
        expect(result[:success]).to eq (false)
        expect(result[:error]).to eq ("Invalid format of hastag. Sample - '#ruby'")
      end

      it "returns false and error for value WITHOUT # " do
        result = TwitterLib::Feed.new.export_posts_by_hashtag("ruby")
        expect(result[:success]).to eq (false)
        expect(result[:error]).to eq ("Invalid format of hastag. Sample - '#ruby'")
      end
    end

  end
end
