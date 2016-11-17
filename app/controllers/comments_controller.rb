class CommentsController < ApplicationController

	def create
		@product = Product.find(params[:product_id])
  	@comment = @product.comments.new(comment_params)
  	@comment.user = current_user
    @user = current_user
    logger.debug("User creating a comment: #{current_user.email }")
    respond_to do |format|
      if @comment.save
        #ActionCable.server.broadcast 'product_channel', comment: @comment, average_rating: @comment.product.average_rating
        #ProductChannel.broadcast_to @product.id, comment: @comment, average_rating: @comment.product.average_rating
        #ProductChannel.broadcast_to @product.id, comment: CommentsController.render(partial: 'comments/comment', locals: {comment: @comment, current_user: current_user}), average_rating: @comment.product.average_rating
        logger.debug("Comment saved successfully!")
        logger.debug("Action cable server- #{ActionCable.server}")
        format.html { redirect_to @product, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @product }
        format.js
      else
        format.html { redirect_to @product, alert: 'Comment was not save successfully.'}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    product = @comment.product
    @comment.destroy
    redirect_to product
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :body, :rating)
  end


  
end
