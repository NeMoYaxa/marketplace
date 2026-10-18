class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @status = Listing.statuses.key?(params[:status]) ? params[:status] : "active"
    @status_counts = current_user.listings.group(:status).count.transform_keys(&:to_s)
    @listings = current_user.listings
                        .where(status: @status)
                        .with_attached_images
                        .order(created_at: :desc)
  end
end
