require_relative '../../lib/first'
require_relative '../../lib/second'
require 'database_cleaner'
require 'spec_helper'

RSpec.describe First do

  describe "First class" do
    let(:second) { `ruby "#{ENV['PATH_TO_PROJECT']}"/module/lib/second.rb` }

    it "has a correct response in first_service if called wrong method" do
      First.new.trigger("test_second_service.something_else", { data: 2 })
      expect(second).to eq "\"Second: testdata\"\n\"Second: \"\n"
    end

    it "doesn`t create record in db if method trigger wasn`t called" do
      expect(Second.on_triggered('test_second_service.test_response')).to eq nil
    end

    it "create record in db if method trigger was called" do
      First.new.trigger_test_service
      expect(Second.on_triggered('test_second_service.test_response')).to eq 'OK'
    end

    it "has a correct response in second_service if methods trigger and broadcast are present" do
      First.new.trigger_test_service
      expect(second).to eq "\"Second: testdata\"\n\"Second: {:data=>2}\"\n"
    end

    it "has a correct response in second_service if method broadcast is present" do
      First.new.trigger_test_service
      second = Second.on_broadcast("test_first_service:started" => :test_response)
      expect(second).to eq "Second: testdata"
    end

    it "has a correct response in first_service if method trigger is present" do
      expect(eval(second)).to eq "Second: {:data=>2}"
    end

    it "has a correct response after performing the methods" do
      expect(second).to eq "\"Second: \"\n\"Second: \"\n"
    end

    it "has a correct response in first_service if method broadcast isn`t present" do
      DatabaseCleaner.clean
      second = Second.on_broadcast("test_first_service:started" => :test_response)
      expect(second).to eq "Second: "
    end
  end
end
