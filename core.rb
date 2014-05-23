require 'bundler'
Bundler.require

class Site
  attr_accessor :score, :domain
  def initialize domain
    url = "http://#{domain}" if URI.parse(domain).scheme.nil?
    @domain = URI.parse(url).host
    @responses = {}
    @pages = {}
    @score = 0
  end

  def get_response uri
    @responses[uri] ||= Net::HTTP.get_response(@domain, URI.parse(uri).path)
  end

  def get_page uri
    @pages[uri] ||= Nokogiri::HTML::Document.parse(get_response(uri).body)
  end
end


class Indicators
  class << self
    def run site
      result = self.new(site).result rescue false
      site.score += 1 if result
      result
    end

    def all
      self.constants.map(&self.method(:const_get)).grep(Class)
    end
  end

  def initialize(site)
    @site = site
  end
end
Dir[File.dirname(__FILE__) + "/indicators/*.rb"].each {|file| require file }
