class ArticlesController < ApplicationController
    before_action :authenticate_request 
    
    def create
        article = Article.new(article_params)
        if article.description != nil
            article.word_count = article.description.split.size
        else
            article.word_count  = 0
        end
        article.user_id=@current_user.id
        
        k = []
        if !fetch_categories.empty?
            article.categories = fetch_categories
            k = fetch_categories.map{|i| (i.slice(:names).values)}
            k = k.flatten
        end

        if article.save
            article = article.slice(:id,:title,:description,:word_count,:user_id,:approved,:likes_count,:dislikes_count)
            article_hsh = article.as_json
            article_hsh['categories'] = k
            # render json: {"article"=>article.slice(:id,:title,:description,:user_id)}, status: 201#response_data
            render json: {"article"=>article_hsh}, status: 201
        else
            render json: { errors: article.errors }, status: 422
        end
    end
    
    def show  
        article = Article.find(params[:id])
        if article.visibilty == true
            comments = Comment.where(article_id:params[:id].to_i)
            article_hsh = article.as_json
            article_hsh['comments'] = comments.map{|comment| {comment.user_id => comment.review}}
            article_hsh['categories'] = article.categories.map{|i| (i.slice(:names).values)}.flatten
            render json: { article: article_hsh}
        else
            render json: {message:"article not found"}
        end
    end

    def update
        article = Article.find(params[:id])
         if @current_user.id == article.user_id
            k=[]
            if article.update(article_params)
                article.word_count = article.description.split.size
                k=article.categories
                k=k.map{|i| (i.slice(:names).values)}.flatten
                article = article.slice(:id,:title,:description,:user_id,:approved,:word_count,:likes_count,:dislikes_count)
                article_hsh = article.as_json
                article_hsh['categories'] = k
                render json: {article:article_hsh}, status: 201
            end
        else
            render json: {message: "No access" }, status: 422
        end
    end

    def destroy
        article = Article.find(params[:id])
        if @current_user.role == 1 or @current_user.id == article.user_id 
            article.visibilty = false
            article.save

            render json: {message: "Deleted"}, status: 200
        else
            render json: {message: "access denied"}, status: 422
        end
    end

    def destroy_ids
        if @current_user.role == 1
            delete_ids = params[:delete].split(',').map{|i| i.to_i}
            delete_ids.each do |i|
                article = Article.find(i)
                article.visibilty = false
                article.save
            end
            render json: {message: "Deleted"}, status: 200
        else
           render json: {errors: "access denied"}, status: 422 
        end
            
    end

    def recover
        if @current_user.role == 1
            article = Article.find(params[:id])
            article.visibilty = true
            article.save
            render json: article
        end
    end

    def approve
        if @current_user.role == 1 or @current_user.role == 2
            article = Article.find(params[:id])
            article.word_count = article.description.split.size
            article.approved = true
            article.save
            render json: {"article"=>article.slice(:id,:title,:description,:user_id,:word_count,:approved,:likes_count,:dislikes_count)}, status: 200
        else
            render json: { message: "access denied" }, status: 422
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
        article = article.select{|i| i.visibilty == true}
        render json: article.sort_by(&:likes_count)

    end

    

    def myarticles
        article = Article.where(user_id:@current_user.id)
        article = article.select{|i| i.visibilty == true}
        render json:article.map {|i| i.slice(:id,:title,:description,:word_count,:approved,:likes_count,:dislikes_count)}
    end

    def get_categories
        Category.where(name: params[:categories])
    end

    private

    def fetch_categories
        categories = []
        if params[:categories] != nil
            params[:categories].each do |category|
                if Category.where(names: category).present?
                    categories += Category.where(names: category)
                else
                    categories << Category.create(names: category)
                end
            end
            
        end
        categories
    end

    def article_params
        params.require(:article).permit(:title, :description)

    end
end

