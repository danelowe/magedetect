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

    # configure Compass so it can find images
    Compass.configuration do |compass|
      compass.project_path = settings.assets_path
      compass.images_dir = 'images'
      compass.output_style = :expanded
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

