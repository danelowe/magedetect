class Indicators::Downloader < Indicators
  def result
    !!(@site.get_page('/downloader/').content =~ /Please re-enter your Magento Adminstration Credentials/)
  end

  def description
    'Magento connect downloader page'
  end

end