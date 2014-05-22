class Indicators::Admin < Indicators
  def result
    !!(@site.get_page('/admin').css('p.legal'))
  end

  def description
    '/admin has legal copyright paragraph'
  end

end