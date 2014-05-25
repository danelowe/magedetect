require 'bundler'
Bundler.require
require_relative 'app/core'
require 'sinatra/sprockets-helpers'

module MageDetect end
class MageDetect::Server < Sinatra::Base
  register Sinatra::Flash
  register Sinatra::Sprockets::Helpers

  configure do
    set :app_root, File.expand_path('../', __FILE__)
    set :sprockets, Sprockets::Environment.new(root)
    set :assets_prefix, '/assets'
    set :assets_path, File.join(settings.app_root, 'app', 'assets')
    set :digest_assets, true
    # setup our paths
    %w(stylesheets javascripts images).each do |asset_directory|
      settings.sprockets.append_path File.join(settings.assets_path, asset_directory)
    end
    # Setup Sprockets
    sprockets.append_path File.join(root, 'app', 'assets', 'stylesheets')
    sprockets.append_path File.join(root, 'app', 'assets', 'javascripts')
    sprockets.append_path File.join(root, 'app', 'assets', 'images')
    configure_sprockets_helpers do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder

      # Force to debug mode in development mode
      # Debug mode automatically sets
      # expand = true, digest = false, manifest = false
      config.debug       = true if development?
    end
  end

  get '/' do
    @errors = []
    @urls = %w[demo.magentocommerce.com]
    @email = 'email@example.com'
    haml :home
  end

  post '/' do
    require 'bundler'
    Bundler.require
    @urls = params[:urls].split("\n")
    @email = params[:email]
    if validate
      SitesWorker.perform_async(@urls, @email)
      flash.now[:success] = 'You will be sent an email with the results as soon as they are processed'
    end
    haml :home
  end

  def validate
    @errors = []
    if @urls.count < 1
      @errors << 'Please enter a URL to test'
    elsif @urls.count > 100
      @errors << 'Please enter no more than 100 URLs'
    end
    if (@email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/).nil?
      @errors << 'Please enter an email address'
    end
    @errors.count == 0
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

