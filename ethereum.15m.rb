#!/usr/bin/env ruby

# <bitbar.title>Ethereum price</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Roman Krasavtsev</bitbar.author>
# <bitbar.author.github>RomanKrasavtsev</bitbar.author.github>
# <bitbar.desc>Get the latest price for Ethereum</bitbar.desc>
# <bitbar.image>https://raw.github.com/romankrasavtsev/ethereum-bitbar-plugin/master/ethereum.png</bitbar.image>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/RomanKrasavtsev/ethereum-bitbar-plugin</bitbar.abouturl>

require "nokogiri"
require "open-uri"
require "date"

SYMBOL = "USD"
TIMES = {
  "5m" => 5/1440.0,
  "10m" => 10/1440.0,
  "1h"  => 1/24.0,
  "3h"  => 3/24.0,
  "6h"  => 6/24.0,
  "12h" => 12/24.0,
  "1d"  => 24/24.0,
  "7d"  => 168/24.0,
  "15d"  => 360/24.0,
  "30d"  => 720/24.0
}

current_price = Nokogiri::HTML(open("https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=#{SYMBOL}"))
  .css('p').first
  .to_s
  .gsub(/<p>{"USD":/, "")
  .gsub(/}<\/p>/, "")
puts "ETH: #{current_price}"

puts "---"

TIMES.each do |text, time|
  timestamp = DateTime.now - time
  price = Nokogiri::HTML(open("https://min-api.cryptocompare.com/data/pricehistorical?fsym=ETH&tsyms=USD&ts=#{timestamp.to_time.to_i}"))
    .css('p').first
    .to_s
    .gsub(/<p>{"ETH":{"USD":/, "")
    .gsub(/\}\}<\/p>/, "")
  percent = current_price.to_i * 100.0 / price.to_i - 100
  puts "-#{text}: #{price} [#{percent.round(2)}%]"
end
