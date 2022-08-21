class CommentsController < ApplicationController
	before_action :authenticate_request
	
	def create
		# debugger
		comment = Comment.new(comment_params)
		comment.user_id = @current_user.id
		comment.article_id = params[:article_id].to_i
		# article = Article.find(params[:article_id])
		if comment.save
			render json: comment, status:201
		else
			render json: {error:comment.errors}, status:422
		end
		# article = Article.find(params[:article_id])
		# comment = article.comments.create(comment_params)
		# render json: comment

	end

	def update
		comment = Comment.find(params[:id])
		if @current_user.id == comment.user_id
			comment.update({"review": params[:review]})
			render json: comment
		else
			render json: {error:"access denied"}, status: 422
		end
	end

	def destroy
		comment = Comment.find(params[:id])
		article = Article.find(params[:article_id])
		if @current_user.role == 1 or @current_user.id == comment.user_id or @current_user.id == article.user_id 
			comment.destroy
			render json: {message:"succesfully deleted"}, status:200
		else
			render json: {error:"no acess"}, status:422
		end
	end


	def index
		comments = Comment.all
		render json: comments
	end

private
	def comment_params
		params.require(:comment).permit(:user_id, :review, :article_id)

	end
end