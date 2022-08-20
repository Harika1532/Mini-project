class UsersController < ApplicationController
    before_action :authenticate_request, except: [:create]


    def create
         # debugger
        user = User.new(user_params)
        if user.save
            #debugger
            render json:{"user"=>user.slice(:id,:email,:password_digest, :role)} , status: 201
        else
            render json: { errors: user.errors }, status: 422
        end
    end
    
    def show
        if @current_user.id == params[:id].to_i
            user=User.find(params[:id])
            render json: user 
        else
            render json: { errors: "denied" }, status: 422
        end
    end

    def update
        if @current_user.id == params[:id].to_i

            user=User.find(params[:id])
            if user.update(user_params)
                render json: user, status:200
            else
                render json: { errors: user.errors }, status: 422
            end
        else
            render json: {error: "denied"}, status: 422
        end
    end

private
    # debugger
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end


end


    