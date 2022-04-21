class UsersController < ApplicationController
    before_action :authenticate, except: [:create]
    
    def index
        render json: User.all
    end
    
    def show
        render json: @current_user
    end
    
    def create
        user = User.new(user_params)
        if user.save
            render json: user
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def update
        if @current_user.update(user_params)
        render json: @current_user
        else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def destroy
        @current_user.destroy
        render json: { message: "User successfully deleted" }
    end
    
    private
    
    def user_params
        params.permit(:username, :password)
    end
    
    def authenticate
        authenticate_or_request_with_http_token do |token, options|
        @current_user = User.find_by(auth_token: token)
        end
    end
end
