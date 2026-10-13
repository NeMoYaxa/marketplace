class ListingsController < ApplicationController
  def show
    @listing = Listing.with_attached_images.includes(:user, :category).find(params[:id])
    @favorite = nil
  end

  def new
    @listing = Listing.new
  end

  def create
    redirect_to new_listing_path
  end
end
