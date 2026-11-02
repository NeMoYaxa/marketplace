class FavoritesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!

  def index
    @listings = current_user.favorite_listings
                              .with_attached_images
                              .includes(:category, :user, :favorites)
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(HomeController::LISTINGS_PER_PAGE)
  end

  def create
    @listing = Listing.find(params[:listing_id])
    return head :forbidden if @listing.user_id == current_user.id

    current_user.favorites.find_or_create_by!(listing: @listing)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to listing_path(@listing) }
    end
  end

  def destroy
    favorite = current_user.favorites.find_by!(listing_id: params[:listing_id])
    @listing = favorite.listing
    favorite.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to favorites_path }
    end
  end
end
