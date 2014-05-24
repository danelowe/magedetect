class Indicators::Installer < Indicators
  def result
    !!(@site.get_page('/install.php').content =~ /ERROR: Magento is already installed/)
  end

  def description
    'Magento connect install.php page'
  end

end