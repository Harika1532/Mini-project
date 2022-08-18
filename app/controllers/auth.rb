def word(s,t)
	s=s.split(//) #[6,5,4,3]
	t=t.split(//)
	c=0
	s.each_with_index do |n,i|
		if n != t[i]        
			k=(t[i].to_i - n.to_i).abs
			# c=c+k if k>5 ? k=10-k : k
			 k = 10 - k if k > 5
			 c = c + k
		end
	end
	return c
end




def create
		comment = article.comments.create(comment_params)
		# comment.user = current_user
		if comment.save
			render json: comment , status:200
		else
			render json: {errors: comment.error}, status:422
		end
	end

	def destroy
		comment = article.comments.find(comment_params)
		if comment.destroy
			render json: {} , status:204
		else
			render json: {errors: comment.error}, status:422
		end
	end

	private

	def set_article
		article = Article.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:body)
	end




def authorized?(email, password)
        debugger
       @current_user = User.find_by(email: email)
     return false unless @current_user
    
         @current_user.authenticate(password)
       end



def authenticate_request
    email,password = user_name_and_password(request)
    render json: {"error":"unauthoried"}, status: :unauthorized
  end
  def authorized?(email,password)
    @current_user = User.find_by(email: email)
    return false unless @current_user
    @current_user.authenticate(password)
  end






