class HomeController < ApplicationController
  LISTINGS_PER_PAGE = 12

  def index
    @listings = Listing.active
                      .with_attached_images
                      .includes(:category, :user, :favorites)
                      .search(params[:query])
                      .by_min_price(params[:min_price])
                      .by_max_price(params[:max_price])
                      .by_city(params[:city])
                      .sorted_by(params[:sort])
                      .page(params[:page])
                      .per(LISTINGS_PER_PAGE)
  end
end
