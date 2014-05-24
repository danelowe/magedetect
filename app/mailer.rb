
class Mailer < ActionMailer::Base
  def csv(email, sites, attachments)
    @sites = sites
    mail = mail(
        to: email,
        from: Sinatra::Application.from_email,
        subject: 'Your MageDetect Results') do |format|
      format.text
      format.html
    end
    attachments.each {|path| mail.attachments[File.basename(path)] = path}
    mail
  end
end

