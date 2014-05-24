configure do
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = settings.smtp_settings.symbolize_keys
end
Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'magedetect', :url => 'redis://127.0.0.1:6379/1' }
end
Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'magedetect', :url => 'redis://127.0.0.1:6379/1' }
end
