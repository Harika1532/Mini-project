class SampleController < ApplicationController

    def index
        render json: {"articler" =>{ params[:key] => params[:value],
                       params[:key1] => params[:value1]}}
        
    end
end
