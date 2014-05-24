require 'spec_helper'
describe Mailer do
  describe '#csv' do
    let(:attachments) { [CSV.open(File.join(SPEC_PATH, 'fixtures', 'test.csv'), 'wb').path] }
    let(:email) { 'to@test.com' }
    let(:sites) { [Site.new('http://demo.magentocommerce.com'), Site.new('www.goodasgold.co.nz')] }
    let(:mail) {  Mailer.csv(email, sites, attachments) }

    it 'renders the subject' do
      expect(mail.subject).to eql('Your MageDetect Results')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql(['to@test.com'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql([Sinatra::Application.from_email])
    end

    it 'attaches attachments' do
      mail.attachments.should have(1).attachment
      attachment = mail.attachments[0]
      attachment.should be_a_kind_of(Mail::Part)
      attachment.content_type.should be_start_with('text/csv;')
      attachment.filename.should == 'test.csv'
    end

    it 'can be delivered' do
      expect { mail.deliver }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end