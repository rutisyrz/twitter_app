require 'erb'

TWITTER = YAML.load(ERB.new(File.read(Rails.root.join("config", "twitter_credential.yml").to_path)).result)[Rails.env]
