class CommentsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!
  before_action :set_listing
  before_action :set_comment, only: :destroy

  def create
    @comment = @listing.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      render turbo_stream: turbo_stream.replace(
        dom_id(@listing, :comment_form),
        partial: "comments/form",
        locals: { listing: @listing, comment: Comment.new }
      )
    else
      render turbo_stream: turbo_stream.replace(dom_id(@listing, :comment_form), partial: "comments/form", locals: { listing: @listing, comment: @comment }), status: :unprocessable_entity
    end
  end

  def destroy
    return head :forbidden unless @comment.user == current_user || current_user.admin?

    @comment.destroy
    head :no_content
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def set_comment
    @comment = @listing.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
