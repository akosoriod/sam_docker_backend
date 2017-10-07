class ApplicationController < ActionController::API

   before_action :validate_token

   private

   def validate_token
    begin
      decoded_token = JWT.decode request.headers['AUTHORIZATION'], ::RSAPublic, true, { :algorithm => 'RS256' }
    rescue Exception
      render status: 401
      return 1
    end
    if decoded_token[0]["typ"] != "Authorization"
      render status: 401
    else
      @username = decoded_token[0]["sub"]
    end
  end


  def ms_ip(ms)
    host = "http://192.168.99.101:"
    case ms
    when "sm" #send mail
      host += "3001"
    when "in" #Inbox
      host += "3002"
    when "nt" #Notifications
      host += "3003"
    when "rg" #Register
      host += "3004"
    when "ss" #Sessions
      host += "3005"
    when "schs" # programacion
      host += "3006"
    end
    return host
  end

end
