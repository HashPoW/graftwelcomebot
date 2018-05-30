#!/usr/bin/env ruby

require 'telegram/bot'

require './lib/message_responder'
require './lib/app_configurator'
require './lib/types/youtube'
require 'nokogiri'
require 'open-uri'

Dir['./models/*'].each {|file| require file unless File.directory?(file)} 

config = AppConfigurator.new
config.configure

token = config.get_token
logger = config.get_logger

ActiveRecord::Base.logger = nil

Telegram::Bot::Client.run(token) do |bot|
  loop do
    puts Youtube.check_first_channel
    puts Youtube.check_second_channel
    puts 'Sleeping'
    sleep 60
  end
end