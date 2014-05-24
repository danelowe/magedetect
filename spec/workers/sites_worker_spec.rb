require_relative '../spec_helper'

class Indicators::Test
  def self.run site
    site.score += 1
    true
  end
end

# We want to stub out create_csv, but using a mock will stub out other methods we want to test.
SitesWorker.instance_eval do
  private
  def create_csv name, sites, header
    CSV.open(File.join(SPEC_PATH, 'fixtures', 'test.csv'), 'wb').path
  end
end

describe SitesWorker do
  describe '#perform' do
    let(:urls) { ['http://demo.magentocommerce.com/', 'www.goodasgold.co.nz'] }
    let(:email) { Sinatra::Application.from_email }
    before do
      allow(Indicators).to receive(:all).and_return([Indicators::Test])
      @mail = double
      @mail.stub(:deliver)
      allow(Mailer).to receive(:csv).and_return(@mail)
    end
    it 'calls all indicators for each url passed in' do
      Indicators::Test.should_receive(:run).exactly(2).times
      SitesWorker.new.perform(urls, email)
    end
    it 'creates a results csv and a summary csv' do
      SitesWorker.any_instance.should_receive(:create_csv).exactly(2).times
      SitesWorker.new.perform(urls, email)
    end
    it 'sends an email to the email passed in' do
      @mail.should_receive(:deliver)
      SitesWorker.new.perform(urls, email)
    end
  end
end