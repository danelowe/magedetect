class Indicators::MediaUrl < Indicators
  def result
    !!(@site.get_page('/').xpath("//img[contains(@src,'/media/')]").count > 0)
  end

  def description
    'Media URL'
  end

end