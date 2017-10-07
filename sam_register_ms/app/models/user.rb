require 'digest'
class User < ApplicationRecord

  validates :firstName, :lastName, :userName, :password, :dateBirth, presence: {message: "Este campo es obligatorio"}
  validates :userName, uniqueness: {message: "El usuario ya se encuentra en uso"}

  validates :password, length: { minimum: 8,
    too_short: "Este campo requiere al menos 8 caracteres" }

  validates :userName, length: { minimum: 5,
    too_short: "Este campo requiere al menos 5 caracteres" }

  def full_name
    "#{firstName}#{" "}#{lastName}"
  end

  def set_user
    self.username
  end

  def self.find_by_username(username)
    where(userName: username).first
  end

end
