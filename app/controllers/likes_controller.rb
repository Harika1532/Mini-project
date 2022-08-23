class LikesController < ApplicationController
	before_action :authenticate_request 
	before_action :set_article
	@@count = 0
	@@count1 = 0
	# before_action :set_like

	def upvote
		# debugger
		if Like.where(user_id: @current_user.id, article_id: @current_article.id).empty? == true
			likes = Like.new(like_params)
			likes.user_id = @current_user.id
			likes.article_id = @current_article.id
			likes.save
			@current_article.likes_count += 1
			@current_article.update(article_params)
			render json: @current_article
		else
			render json: {error: "denied"}
		end
	end

	def downvote
		if Like.where(user_id: @current_user.id, article_id: @current_article.id).empty? == true
			likes = Like.new(like_params)
			likes.user_id = @current_user.id
			likes.article_id = @current_article.id
			likes.save
			@current_article.dislikes_count += 1
			@current_article.update(article_params)
			render json: @current_article
		else
			render json: {error: "denied"}
		end
	end




	

	def set_article
		@current_article = Article.find(params[:id])
	end

	def article_params
        params.fetch(:article, {}).permit(:likes_count, :dislikes_count)
    end
	
private

    def like_params
        params.fetch(:like, {}).permit(:user_id, :article_id, :likes_count)
    end
end