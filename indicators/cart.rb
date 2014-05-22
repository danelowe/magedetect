class Indicators::Cart < Indicators
  def result
    !!(@site.get_page('/checkout/cart').css('body[class~="checkout-cart-index"]'))
  end

  def description
    '/checkout/cart success and has correct body class'
  end

end