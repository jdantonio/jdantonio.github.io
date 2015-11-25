#!/usr/bin/env ruby

require 'concurrent'
require 'open-uri' # for open(uri)

SYMBOLS = ['MA', 'PCLN', 'ADP', 'V', 'TSS', 'FISV', 'EBAY', 'PAYX', 'WDC', 'SYMC',
           'AAPL', 'AMZN', 'KLAC', 'FNFV', 'XLNX', 'MSI', 'ADI', 'VRSN', 'CA', 'YHOO']
YEAR = 2014

def get_year_end_closing(symbol, year)
  uri = "http://ichart.finance.yahoo.com/table.csv?s=#{symbol}&a=01&b=04&c=#{year}&d=01&e=14&f=#{year+1}&g=d&ignore=.csv "
  data = open(uri) {|f| f.collect{|line| line.strip } }
  data[1].split(',')[4].to_f
end

futures = SYMBOLS.collect do |symbol|
  Concurrent::Future.execute { get_year_end_closing(symbol, year) }
end

puts futures.collect { |future| future.value }
