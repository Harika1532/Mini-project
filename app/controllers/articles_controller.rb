class ArticlesController < ApplicationController
      
    
    def create
        #debugger
        article = Article.new(article_params )
        article.word_count = article.description.split.size
        if article.save
            #debugger
            
            # render json: {"article"=>article.slice(:id,:title,:description,:user_id)}, status: 201#response_data
            render json: article, status: 201
            
            
        else
            render json: { errors: article.errors }, status: 422
        end
    end
    
    def show  
        article = Article.find(params[:id])
        article.word_count = article.description.split.size
        render json: article
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
            render json: { errors: article.errors }, status: 422
        end
    end

     def index
        
        article = Article.all
    
        
        render json: article.sort_by(&:title)
    end

    def approve
        
            article = Article.find(params[:id])
            if article.update(article_params)
                render json: article, status: 200
            else
                render json: { errors: article.errors }, status: 422
            end

     end

    def index
        article = Article.all
        # articles = articles.sort
        render json: article.sort_by(&:title)
    end

    def myarticles
        article = Article.where(user_id:User.find(params[:id]))
        render json:article
    end

    private

    def article_params
        params.require(:article).permit(:title, :description, :approved, :user_id, :word_count)
    end
end