require "rails_helper"

describe GemfileParser do
  describe "#parse" do
    it "returns a hash with gem and versions for a given Gemfile.lock" do
      raw_file = File.open("spec/assets/SampleGemfile.lock", "r+").read

      expected_hash = {"actionmailer"=>"4.2.3", "actionpack"=>"4.2.3", "actionview"=>"4.2.3", "activejob"=>"4.2.3",
                       "activemodel"=>"4.2.3", "activerecord"=>"4.2.3", "activesupport"=>"4.2.3", "arel"=>"6.0.0",
                       "binding_of_caller"=>"0.7.2", "builder"=>"3.2.2", "byebug"=>"5.0.0", "coderay"=>"1.1.0",
                       "coffee-rails"=>"4.1.0", "coffee-script"=>"2.4.1", "coffee-script-source"=>"1.9.1.1",
                       "columnize"=>"0.9.0", "coveralls"=>"0.8.2", "debug_inspector"=>"0.0.2", "diff-lcs"=>"1.2.5",
                       "docile"=>"1.1.5", "domain_name"=>"0.5.24", "erubis"=>"2.7.0", "execjs"=>"2.5.2",
                       "factory_girl"=>"4.5.0", "factory_girl_rails"=>"4.5.0", "faker"=>"1.4.3", "globalid"=>"0.3.5",
                       "http-cookie"=>"1.0.2", "i18n"=>"0.7.0", "jbuilder"=>"2.3.0", "jquery-rails"=>"4.0.4",
                       "json"=>"1.8.3", "loofah"=>"2.0.2", "mail"=>"2.6.3", "method_source"=>"0.8.2", "mime-types"=>"2.6.1",
                       "mini_portile"=>"0.6.2", "minitest"=>"5.7.0", "multi_json"=>"1.11.1", "mysql2"=>"0.3.18",
                       "netrc"=>"0.10.3", "nokogiri"=>"1.6.6.2", "pry"=>"0.10.1", "rack"=>"1.6.4", "rack-test"=>"0.6.3",
                       "rails"=>"4.2.3", "rails-deprecated_sanitizer"=>"1.0.3", "rails-dom-testing"=>"1.0.6",
                       "rails-html-sanitizer"=>"1.0.2", "railties"=>"4.2.3", "rake"=>"10.4.2", "rdoc"=>"4.2.0",
                       "rest-client"=>"1.8.0", "rspec-core"=>"3.3.2", "rspec-expectations"=>"3.3.1", "rspec-mocks"=>"3.3.2",
                       "rspec-rails"=>"3.3.3", "rspec-support"=>"3.3.0", "sass"=>"3.4.15", "sass-rails"=>"5.0.3", "sdoc"=>"0.4.1",
                       "shoulda-matchers"=>"2.8.0", "simplecov"=>"0.10.0", "simplecov-html"=>"0.10.0", "slop"=>"3.6.0",
                       "spring"=>"1.3.6", "sprockets"=>"3.2.0", "sprockets-rails"=>"2.3.2", "term-ansicolor"=>"1.3.2",
                       "thor"=>"0.19.1", "thread_safe"=>"0.3.5", "tilt"=>"1.4.1", "tins"=>"1.5.4", "turbolinks"=>"2.5.3",
                       "tzinfo"=>"1.2.2", "uglifier"=>"2.7.1", "unf"=>"0.1.4", "unf_ext"=>"0.0.7.1", "web-console"=>"2.1.3"}

      expect(GemfileParser.new(raw_file).parse).to be_eql expected_hash
    end
  end
end