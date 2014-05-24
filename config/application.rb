configure do
  ActionMailer::Base.view_paths = "./views/"
end

env = ENV['RACK_ENV'] || 'development'
require_relative "environment/#{env}"