require 'core'

urls = ['http://demo.magentocommerce.com/', 'http://www.tradetested.co.nz', 'http://www.wocolate.co.nz']

urls.each do |url|
  puts "\n"
  puts '=============================='
  puts url
  puts '=============================='
  site = Site.new url
  Indicators.all.each {|i| puts(i.run(site).to_s+' | '+i.name)}
end
