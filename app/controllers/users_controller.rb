class UsersController < ApplicationController
    # debugger
    # user = User.find(user_params)
    # http_basic_authenticate_with name:"a@a", password:"aaa"
    # before_action :authenticate, :only => [:show] 
    # before_action :current_user

    # user = User.find(email: user_params[:email])
    # user.authenticate(user_params)



    # def user_name_and_password(request)
    #     debugger
    #     decode_credentials(request).split(":", 2)
    # end
    def create
         # debugger
        user = User.create(user_params)
        render json: {"user": user_params}, status: 201

        # if user.save
        #     #debugger
        #     render json: user, status: 201
        # else
        #     render json: { errors: user.errors }, status: 422
        # end
        # if user.present? && user.authenticate(params[:password_digest])
        #     current_user = user.id
        # end


        
    end



    # User.find(params[:id])["email"]
    


    
    def show

        user=User.find(params[:id])
        

    #      if http_basic_authenticate_or_request_with name:user.email, password:user.password_digest
            # current_user = user
    #       # render json: user, status:201
            render json: {"user"=>user.slice(:id,:email,:password,:role)} 
        # else
        #     render json: { errors: user.errors }, status: 422
        # end

    
    end

    def update
        user=User.find(params[:id])
        if user.update(user_params)
            render json: user, status:200
        else
            render json: { errors: user.errors }, status: 422
        end
    end


  
  def index
    user=User.all
    render json: user, status: 200
  end


private
    # debugger
    def user_params
        params.require(:user).permit(:email,  :password, :password_confirmation, :role)
    end


end


    