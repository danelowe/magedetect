class Indicators::Cookie < Indicators
  def result
    response = @site.get_response('/')
    !!((response.header['set-cookie'] =~ /^frontend=(.*); HttpOnly$/) || response.header['x-magento-action'].present?)
  end

  def description
    'Cookie'
  end

end