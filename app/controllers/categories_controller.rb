class CategoriesController < ApplicationController
    before_action :authenticate_request
    before_action :set_article, except: [:index]

    def index

        category = Category.where(names:params[:name])
        if category != []
            render json: category.first.articles
        else
            render json: {message: "Articles with this category are not found"}
        end
    end

    def update
        if @current_user == @article.user_id or @current_user.role == 1
            k = []
            if !fetch_categories.empty?
                @article.categories = fetch_categories
                k = fetch_categories.map{|i| (i.slice(:names).values)}
                k = k.flatten
            end
           
            @article = @article.slice(:id,:title,:description,:word_count,:likes_count,:dislikes_count)
            article_hsh = @article.as_json
            article_hsh['categories'] = k
            render json: {"article"=>article_hsh}
        else:
           render json: {message: "Access denied"} 
        end

    end

    def set_article
        @article = Article.find(params[:id])
    end


    

    private
    def fetch_categories
        names = []
        if params[:names] != nil
            params[:names].each do |category|
                if Category.where(names: category).present?
                    names += Category.where(names: category)
                else
                    names << Category.create(names: category)
                end
            end
            
        end
        names
    end

    def category_params
       params.require(:category).permit(:names)
    end
end
