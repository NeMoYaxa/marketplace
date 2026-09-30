class ListingsController < ApplicationController
  def new
    @listing = Listing.new
  end

  def create
    redirect_to new_listing_path
  end
end
