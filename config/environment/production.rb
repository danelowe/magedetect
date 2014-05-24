configure do
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings settings.smtp_settings.symbolize_keys
end
