urls = ['http://demo.magentocommerce.com/', 'http://www.tradetested.co.nz', 'http://www.wocolate.co.nz']
require 'bundler'
Bundler.require

class Site
  def initialize domain
    @domain = domain
    @responses = {}
    @pages = {}
  end

  def get_response uri
    @responses[uri] ||= Net::HTTP.get_response(URI.parse(@domain).host, URI.parse(uri).path)
  end

  def get_page uri
    @pages[uri] ||= Nokogiri::HTML::Document.parse(get_response(uri).body)
  end
end


class Indicators
  class << self
    def run site
      self.new(site).result rescue false
    end
  end

  def initialize(site)
    @site = site
  end

end

Dir[File.dirname(__FILE__) + "/indicators/*.rb"].each {|file| require file }
indicators = Indicators.constants.map(&Indicators.method(:const_get)).grep(Class)
urls.each do |url|
  puts "\n"
  puts '=============================='
  puts url
  puts '=============================='
  site = Site.new url
  indicators.each {|i| puts(i.run(site).to_s+' | '+i.name)}
end
