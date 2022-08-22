class ArticlesController < ApplicationController
    before_action :authenticate_request 
    
    def create
        #debugger
        article = Article.new(article_params )
        article.word_count = article.description.split.size
        article.user_id=@current_user.id
        if article.save
            # render json: {"article"=>article.slice(:id,:title,:description,:user_id)}, status: 201#response_data
            render json: article, status: 201
        else
            render json: { errors: article.errors }, status: 422
        end
    end
    
    def show  
        article = Article.find(params[:id])
        comments = Comment.where(article_id:params[:id].to_i)
        categories = ArticleCategory.where(article_id:params[:id].to_i) 
        # article.word_count = article.description.split.size
        render json: {"article":article, "categories":categories, "comments":comments.map{|comment| comment.slice(:user_id,:review)}}

    end

    def update
        article = Article.find(params[:id])
         if @current_user.id == article.user_id
            if article.update(article_params)
                article.word_count = article.description.split.size
                render json: article, status: 200
            end
        else
            render json: { errors: "No access" }, status: 422
        end
    end

    def destroy
        #debugger
        article = Article.find(params[:id])
        if @current_user.role == 1 or @current_user.id == article.user_id 
            article.destroy

            render json: {message: "Deleted"}, status: 200
        else
            render json: {errors: "access denied"}, status: 422
        end
    end

     

    def approve
        if @current_user.role == 1 or @current_user.role == 2
        
            article = Article.find(params[:id])
            article.approved = true
            article.save
            render json: article, status: 200
        else
            render json: { errors: "access denied" }, status: 422
        end
    end

    def index
        if params[:approved]!= nil && params[:user_id]!=nil
            article = Article.where(approved:params[:approved], user_id:params[:user_id])
        elsif params[:approved]!=nil
            article = Article.where(approved:params[:approved])
        elsif params[:user_id]!=nil
            article = Article.where(user_id:params[:user_id])
        else 
            article = Article.where(approved:true)
        end
        render json: article.sort_by(&:title)

    end

    def myarticles
        article = Article.where(user_id:params[:id].to_i)
        if @current_user.id == params[:id].to_i
            render json:article
        else

            render json: article.where(approved:true)
        end
    end

private

    def article_params
        params.require(:article).permit(:title, :description)
    end
end