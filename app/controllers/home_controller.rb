class HomeController < ApplicationController
  LISTINGS_PER_PAGE = 12

  def index
    # Демо заглушки
    listing = Struct.new(:id, :title, :price, :city, :created_at).new(
      1,
      "Демонстрационное объявление",
      12_500,
      "Москва",
      3.days.ago
    )

    @listings = [ listing ]
    @cities = [ listing.city ]
    @total_pages = [ (@listings.size.to_f / LISTINGS_PER_PAGE).ceil, 1 ].max
  end
end
