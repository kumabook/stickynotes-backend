class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      at = access_token
      uh = sorcery_fetch_user_hash(provider)
      @user.authentications
        .select {|a| a.provider == provider}
        .each {|a|
        a.access_token  = at.token
        a.access_secret = at.secret
        a.image_url     = uh["profile_image_url"]
        a.save!
      }
      redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, :notice => "Logged in from #{provider.titleize} first!"
      rescue => e
        redirect_to root_path, :notice => "Failed to login from #{provider.titleize}!"
      end
    end
  end

  private
  def auth_params
    params.permit(:code, :provider, :oauth_token, :oauth_verifier)
  end
end
