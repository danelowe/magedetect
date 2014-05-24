class Indicators::JsCookiesPath < Indicators
  def result
    page = @site.get_page('/')
    !!((page.content =~ /Mage\.Cookies\.path/) || (page.content =~ /Mage\.Cookies\.domain/))
  end

  def description
    'Mage.Cookies.path || Mage.Cookies.domain'
  end

end