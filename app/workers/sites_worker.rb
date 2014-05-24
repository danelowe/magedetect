require_relative '../core'

class SitesWorker
  include Sidekiq::Worker

  def perform(urls, email)
    sites = []
    attachments = []
    stamp = Time.now.strftime('%Y-%m-%d-%H:%M:%S')+'-'+SecureRandom.hex(6)
    urls.each {|url| sites << Site.new(url)}

    attachments << create_csv('results-'+stamp, sites, %w[domain result test]) do |site|
      Indicators.all.map { |i| [site.domain, i.run(site).to_s, i.name] }
    end
    attachments << create_csv('summary-'+stamp, sites, %w[domain score max]) do |site|
      [[site.domain, site.score, Indicators.all.count]]
    end

    Mailer.csv(email, sites, attachments).deliver
  end

  private

  def create_csv name, sites, header
    Dir.mkdir('csvs') unless File.exists?('csvs')
    ::CSV.open(File.join('csvs', "#{name}.csv"), "wb") do |csv|
      csv << header
      sites.each do |site|
        yield(site).each {|row| csv << row}
      end
      csv.path
    end
  end

end