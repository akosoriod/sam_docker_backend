class SessionsController < ApplicationController

skip_before_action :validate_token, only: [:refresh_token, :login]

  def login
    login = HTTParty.post(ms_ip("rg")+"/users/login", body: {
      username: params[:username],
      password: params[:password]
    }.to_json,
      :headers => { 'Content-Type' => 'application/json' })
    if login.code == 200
      device_reg = HTTParty.post(ms_ip("nt")+"/user_devices", body:{
        username: params[:username],
        device_id: params[:device_id]
      }.to_json,
      :headers => { 'Content-Type' => 'application/json' })
      if device_reg.code == 201
        token = HTTParty.get(ms_ip("ss")+"/token/"+params[:username])
        render status: token.code, json: token.body
      else
        render json: device_reg.body, status: device_reg.code
      end
    else
      render status: 404
    end
  end

  def refresh_token
    results = HTTParty.get(ms_ip("ss") + "/refresh", headers:{
      "Authorization": request.headers['AUTHORIZATION']
      })
      render status: results.code, json: results.body
  end

  def logout
    results = HTTParty.delete(ms_ip("ss") + "/revoke", headers:{
      "Authorization": request.headers['AUTHORIZATION']
      })
      render status: results.code, json: results.body
  end

  def remove_tokens
    results = HTTParty.delete(ms_ip("ss") + "/revoke/"+@username, headers:{
      "Authorization": request.headers['AUTHORIZATION']
      })
      render status: results.code, json: results.body
  end

end
