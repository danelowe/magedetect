require_relative '../core'

class ScreenWorker
  include Sidekiq::Worker

  def perform(url)
    site = Site.new(url)
    if Indicators::SkinUrl.run(site)
      File.open('results', 'a') { |f| f.write("\n"+site.domain) }
    else
      site = Site.new('www.'+url)
      File.open('results', 'a') { |f| f.write("\n"+site.domain) } if Indicators::SkinUrl.run(site)
    end
  end
end