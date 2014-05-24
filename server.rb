require 'bundler'
Bundler.require
require_relative 'app/core'
module MageDetect end
class MageDetect::Server < Sinatra::Base
  register Sinatra::Flash

  get '/' do
    @urls = %w[demo.magentocommerce.com]
    @email = 'email@example.com'
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

  # start the server if ruby file executed directly
  run! if app_file == $0
end

