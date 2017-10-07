class UsersController < ApplicationController

  skip_before_action :validate_token, only: [:create_user]
  before_action :use_token, only: [:update_user, :destroy_user]

# No dependen del token
    def create_user
      value = user_params.to_h
      value.deep_transform_keys!{ |key| key.to_s.camelize(:lower) }
      value["userName"] = value.delete("username")
      create_user = HTTParty.post(ms_ip("rg")+"/users", body: value.to_json, :headers => { 'Content-Type' => 'application/json' })
      if create_user.code == 200
        render status: 200, json: {body:{message: "Usuario creado"}}.to_json
      else
        render status: create_user.code, json: create_user.body
      end
    end

# Dependen del token

    def index_user
      results = HTTParty.get(ms_ip("rg")+"/users")
      render json: results.body, status: results.code
    end

    def show_user
      results = HTTParty.get(ms_ip("rg")+"/users/"+ params[:id].to_s)
      render json: results.body, status: results.code
    end

    def update_user
      value = user_params.to_h
      value.deep_transform_keys!{ |key| key.to_s.camelize(:lower) }
      value["userName"] = value.delete("username")
      update_user = HTTParty.put(ms_ip("rg")+"/users/"+@username, body: value, query:{user:value})
      if update_user.code == 200
        render status: 200, json: {body:{message: "Usuario actualizado"}}.to_json
      else
        render status: update_user.code, json: update_user.body
      end
    end

    def destroy_user
      results = HTTParty.delete(ms_ip("rg")+"/users/"+@username)
      if results.code == 200
        render status: 200, json: {body:{message: "Usuario borrado"}}.to_json
      else
        render status: 404, json: {body:{message: "El usuario no ha podido ser borrado"}}.to_json
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :password, :gender, :date_birth, :mobile_phone, :current_email, :location)
    end


    def use_token
      if params[:username] != @username
        render status:400, json:{message: "No autorizado"}
      end
    end
end
