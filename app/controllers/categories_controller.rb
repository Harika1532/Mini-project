class CategoriesController < ApplicationController
    def create
        #debugger
        category = Category.create(category_params )
        if category.save
            render json: category, status: 201
        else
            render json: { errors: category.errors }, status: 422
        end
    end
    def show
        category = Category.find(params[:id])
        render json: category
    end

    

    def update
        category=Category.find(params[:id])
        category.update(category_params)
        render json: category
    end

    private
    def category_params
       params.require(:category).permit(:name)
    end
end