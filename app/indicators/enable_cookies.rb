class Indicators::EnableCookies < Indicators
  def result
    !!(@site.get_page('/enable-cookies').css('body[class~="cms-enable-cookies"]'))
  end

  def description
    '/enable-cookies page'
  end

end