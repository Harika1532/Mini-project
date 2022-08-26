class LikesController < ApplicationController
	before_action :authenticate_request 
	before_action :set_article, except:[:liked_articles]

	def upvote
		if @current_article.approved == true and @current_article.visibilty == true
			if Like.where(user_id: @current_user.id, article_id: @current_article.id).empty? == true
				likes = Like.new(like_params)
				likes.user_id = @current_user.id
				likes.article_id = @current_article.id
				likes.like = true
				likes.save
				@current_article.likes_count += 1
				@current_article.save
				
				render json: {article:@current_article.slice(:id,:title,:description,:user_id,:word_count,:approved,:likes_count,:dislikes_count)}
			else
				likes = Like.find_by(user_id: @current_user.id, article_id: @current_article.id)
				if likes.dislike == true
					@current_article.dislikes_count -= 1
					@current_article.save
					likes.dislike = false
					likes.save
				end
				if likes.like == false 
					@current_article.likes_count += 1
					@current_article.save
					likes.like = true
					likes.save
				else
					@current_article.likes_count -= 1
					@current_article.save
					likes.like = false
					likes.save
				end

				render json: {article:@current_article.slice(:id,:title,:description,:user_id,:word_count,:approved,:likes_count,:dislikes_count)}
			end
		else
			render json: {message:"Article is not published or not present"}

		end
	end

	def downvote
		if @current_article.approved == true and @current_article.visibilty == true
			if Like.where(user_id: @current_user.id, article_id: @current_article.id).empty? == true
				likes = Like.new(like_params)
				likes.user_id = @current_user.id
				likes.article_id = @current_article.id
				likes.dislike = true
				likes.save
				@current_article.dislikes_count += 1
				@current_article.save
				render json: {article:@current_article.slice(:id,:title,:description,:user_id,:word_count,:approved,:likes_count,:dislikes_count)}
			else
				likes = Like.find_by(user_id: @current_user.id, article_id: @current_article.id)
				if likes.like == true
					@current_article.likes_count -= 1
					@current_article.save
					likes.like = false
					likes.save
				end
				
				if likes.dislike == true
					@current_article.dislikes_count -= 1
					@current_article.save
					likes.dislike = false
					likes.save
				else
					@current_article.dislikes_count += 1
					@current_article.save
					likes.dislike = true
					likes.save
				end
				render json: {article:@current_article.slice(:id,:title,:description,:user_id,:word_count,:approved,:likes_count,:dislikes_count)}
			end
		else
			render json: {message:"Article is not published or not present to dislike"}

		end	
	end

	def liked_articles
		articles = []
		likes = Like.where(user_id: @current_user.id)
		likes.each do |like|
			articles << Article.find(like.article_id)
		end
		render json: articles.sort_by(&:likes_count)
	end

	def liked_users
		users =[]
		likes = Like.where(article_id: @current_article.id)
		likes.each do |like|
			users << User.find(like.user_id)
		end
		render json: users.map{|i| (i.slice(:id,:email))}
	end


	def set_article
		@current_article = Article.find(params[:id])
	end

	private

    	def like_params
        	params.fetch(:like, {}).permit(:user_id, :article_id, :like, :dislike)
    	end
end