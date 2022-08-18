class ApplicationController < ActionController::Base
  #debugger
  include ActionController::HttpAuthentication::Basic
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request
  

  def authenticate_request
    email,password = user_name_and_password(request)
    render json: {"error":"unauthoried"}, status: :unauthorized if !authorized?(email, password)
  
  end

  def authorized?(email,password)
    @current_user = User.find_by(email: email)
    return false unless @current_user
    @current_user.authenticate(password)
  end
end
