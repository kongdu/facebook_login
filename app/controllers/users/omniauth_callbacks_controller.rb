# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
 def auth
   request.env['omniauth.auth']
   # redirect_to root_path
 end

 def facebook
   # auth hash는 위에 있는 주석
    # 만약 유저가 facebook을 통해 회원가입을 한 적 있으면
    service = Service.where(provider: auth.provider uid: auth.uid).first
    if service.present?
    # 유저를 가져오면 된다.
     user = service.user #service belongs_to user / 그 서비스가 가지고 있는 유저를 가져온다
    # 아니면?
    else
    # 유저를 생성하면된다
    user = User.create(
      email: auth.info.email,
      password: Devise.friendly_token[0,20]
    )
    # 유저를 생성하면서, 서비스에 facebook에 정보를 담아 놓는다
      user.services.create(
        provider: auth.provider,
        uid: auth.uid,
        expires_at: Time.at(auth.credentials.expires_at),
        access_token: auth.credentials.token
      ) # Service.new랑 같은데 user_id column에 user id값이 들어간다
    end
  sign_in_and_redirect userm event: authenticate
 end
end
