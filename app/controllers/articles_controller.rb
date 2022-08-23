class ArticlesController < ApplicationController
    before_action :authenticate_request 
    # before_action :set_k
    
    def create
        #debugger
        article = Article.new(article_params)
        article.word_count = article.description.split.size
        article.user_id=@current_user.id
        article.categories = fetch_categories
        #params[:categories].map{|i| Category.create({"name":i})}
        # params[:categories].map{|category| ArticleCategory.create({"article_id": article.id, "category_id": category})}
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
        # likes = Like.where(article_id:params[:id].to_i).count
        # categories = ArticleCategory.where(article_id:params[:id].to_i) 
        # article.word_count = article.description.split.size
        # k = comments.map{|comment| comment.slice(:user_id,:review)}
        render json: {"article":article.merge  "comments":comments.map{|comment| {comment.user_id => comment.review}}}
        # render json: article#.merge comments
    end

    def update
        article = Article.find(params[:id])
         if @current_user.id == article.user_id
            # article = Article.find(params[:id])
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
        if @current_user.id == params[:id].to_i
        article = Article.where(user_id:params[:id].to_i)
        # if @current_user.id == params[:id].to_i
            render json:article
        else

            render json: article.where(approved:true)
        end
            
    end

private

    def fetch_categories
        categories = []
        params[:categories].each do |category|
            if Category.where(name: category).present?
                categories += Category.where(name: category)
            else
                categories << Category.create(name: category)
            end
        end
        categories
    end


    def article_params
        params.require(:article).permit(:title, :description, :likes_count, :dislikes_count)
    end
end