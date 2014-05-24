require 'rubygems'
require 'sinatra'

set :public_dir, File.expand_path(File.dirname(__FILE__) + '/public')
set :views, File.expand_path(File.dirname(__FILE__) + '/views')
set :environment, :production
disable :run, :reload
require './server'
map MageDetect::Server.settings.assets_prefix do
  run MageDetect::Server.sprockets
end
# main app
map '/' do
  run MageDetect::Server
end
