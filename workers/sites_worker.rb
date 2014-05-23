require 'csv'
require_relative '../core'

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'Barcelona', :url => 'redis://127.0.0.1:6379/1' }
end
Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'Barcelona', :url => 'redis://127.0.0.1:6379/1' }
end
class SitesWorker
  include Sidekiq::Worker

  def perform(urls, email)
    sites = []
    stamp = Time.now.strftime('%Y-%m-%d-%H:%M:%S')+'-'+SecureRandom.hex(6)
    urls.each {|url| sites << Site.new(url)}
    Dir.mkdir('csvs') unless File.exists?('csvs')
    ::CSV.open(File.join('csvs', "results-#{stamp}.csv"), "wb") do |csv|
      csv << %w[domain result test]
      sites.each do |site|
        Indicators.all.each do |i|
          csv << [site.domain, i.run(site).to_s, i.name]
        end
      end
    end
    ::CSV.open(File.join('csvs', "summary-#{stamp}.csv"), "wb") do |csv|
      csv << %w[domain score max]
      sites.each do |site|
        csv << [site.domain, site.score, Indicators.all.count]
      end
    end
  end
end