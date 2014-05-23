require 'bundler'
Bundler.require
require_relative 'core'
require_relative 'workers/sites_worker'


Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'Barcelona', :url => 'redis://127.0.0.1:6379/1' }
end

get '/' do
  @urls = %w[demo.magentocommerce.com]
  @email = 'magedetect@avidonline.co.nz'
  haml :home
end
post '/' do
  require 'bundler'
  Bundler.require
  @urls = params[:urls].split("\n")
  @email = params[:email]
  SitesWorker.perform_async(@urls, @email)
  flash.now[:success] = 'You will be emailed'
  haml :home
end