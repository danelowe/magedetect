class Indicators::SkinUrl < Indicators
  def result
    !!(@site.get_page('/').xpath("/html/head/link[contains(@href,'/skin/frontend')]").count > 0)
  end

  def description
    'Skin URL'
  end

end