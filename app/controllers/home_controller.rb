class HomeController < ApplicationController
  LISTINGS_PER_PAGE = 12

  def index
    @listings = Listing.active
                      .with_attached_images
                      .includes(:category, :user, :favorites)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(LISTINGS_PER_PAGE)
  end
end
