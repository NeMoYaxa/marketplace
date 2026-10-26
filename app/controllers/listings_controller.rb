class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: %i[edit update destroy update_status]

  def show
    @listing = Listing.with_attached_images.includes(:user, :category).find(params[:id])
    @favorite = nil
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.build(listing_params)

    if @listing.save
      redirect_to @listing, notice: "Объявление опубликовано"
    end
  end

  def destroy
    @listing.destroy
    redirect_to root_path, notice: "Объявление удалено"
  end

  def update
    if @listing.update(listing_params.except(:images))
      attach_new_images
      redirect_to @listing, notice: "Объявление обновлено"
    end
  end

  def update_status
    if params[:status].in?(Listing.statuses.keys)
      @listing.update!(status: params[:status])
      redirect_back_or_to @listing, notice: "Статус изменён"
    end
  end

  private

  def set_listing
    @listing = current_user.listings.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :price, :city, :category_id, images: [])
  end

  def attach_new_images
    new_images = Array(listing_params[:images]).reject(&:blank?)
    @listing.images.attach(new_images) if new_images.any?

    if params[:remove_image_ids].present?
      @listing.images.where(id: params[:remove_image_ids]).find_each(&:purge_later)
    end
  end
end
