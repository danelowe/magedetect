class Indicators::JsVariables < Indicators
  def result
    page = @site.get_page('/')
    !!((page.to_s =~ /var BLANK_URL = /) || (page.to_s =~ /var BLANK_IMG = /))
  end

  def description
    'BLANK_URL || BLANK_IMG'
  end

end