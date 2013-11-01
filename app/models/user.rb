class User < ActiveRecord::Base
  private_class_method :new
  before_save :ensure_authentication_token

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable,
  #       :rememberable, :trackable, :token_authenticatable
#  :validatable,:registerable,:recoverable,

  #devise :omniauthable, :omniauth_providers => [:facebook]

  devise :token_authenticatable

  # uid 로 unique user 생성
  # TODO - new로 생성하지 못하게 막아야함 or uid, provider 체크
  def self.find_or_create_user_by_uid uid, kakao_access_token
    provider = "kakao"

    user = User.where(:provider => provider, :uid => uid).first
    unless user
      user = User.create(:provider => provider, :uid => uid)
    end

    if user.kakao_access_token != kakao_access_token
      user.kakao_access_token = kakao_access_token
      user.is_validated = nil
      user.save!
    end

    return user
  end
end
