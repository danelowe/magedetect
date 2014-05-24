require_relative 'spec_helper.rb'

describe MageDetect::Server do
  it 'Responds with success on home page' do
    get '/'
    last_response.should be_ok
  end
end