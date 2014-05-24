require 'rubygems'
require 'sinatra'

set :public_dir, File.expand_path(File.dirname(__FILE__) + '/public')
set :views, File.expand_path(File.dirname(__FILE__) + '/views')
set :environment, :production
disable :run, :reload
require_relative 'server'
run MageDetect::Server