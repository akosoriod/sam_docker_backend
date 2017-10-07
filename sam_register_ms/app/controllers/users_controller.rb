require 'digest'
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_user_username, only: [:login]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end


  # POST /users
  def create
    @user = User.new(user_params)
    @user.password = Digest::SHA256.hexdigest(params[:password])

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
      @user.password = Digest::SHA256.hexdigest(params[:password])
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    render status: 404 if @user.blank?
    @user.destroy
    render status: 200
  end

  def login
    if @user.blank?
      render status: 404
    else
      if @user.password == Digest::SHA256.hexdigest(params[:password])
        render status: 200
      else
        render status: 401
      end
    end
  end

  private

    def set_user_username
      @user = User.find_by_username(params[:userName])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_username(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:firstName, :lastName, :userName, :password, :gender, :dateBirth, :mobilePhone, :currentEmail, :location)
    end
end
