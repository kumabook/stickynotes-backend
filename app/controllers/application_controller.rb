class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def json_request?
    request.format.json?
  end

  protected
  def admin?
    current_user && current_user.admin?
  end

  def require_admin
    unless admin?
      redirect_to root_path
    end
  end

  def render_forbidden
    respond_to do |format|
      format.html {
        render file: "#{Rails.root}/public/403.html", status: :forbidden
      }
      format.json { render json: {}, status: :forbidden }
    end
  end

  def render_not_found
    respond_to do |format|
      format.html {
        render file: "#{Rails.root}/public/404.html", status: :not_found
      }
      format.json { render json: {}, status: :not_found }
    end
  end

  private
  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
