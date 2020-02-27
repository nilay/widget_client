class ApplicationController < ActionController::Base
	include ApplicationHelper
	protect_from_forgery with: :exception

  before_action :set_session_and_user

  after_action :set_cookies


	# Resolves current user.
	def current_user
		@current_user ||= (User.new(session[:user_information]) if session[:user_information].present?)
	end

  def set_session_and_user
    @user = User.new
    @session = Session.new
  end

  def set_cookies
    session[:user_information] = current_user
  end

  rescue_from RestClient::UnprocessableEntity do
    redirect_to root_path, alert: 'Sorry, you are not allowed to do that.'
  end

  rescue_from RestClient::Unauthorized do
    redirect_to root_path, alert: 'Sorry, you are not allowed to do that.'
  end


  helper_method :current_user

  private

	def extract_user_information(response)
    data = {}
    if response[:data]
      response = response[:data]
    end
    if response[:user]
      data[:id] = response[:user][:id]
      data[:email] = response[:user][:email]
    end

    if response[:token]
      data[:access_token] = response[:token][:access_token]
      data[:refresh_token] = response[:token][:refresh_token]
      data[:expires_in] = response[:token][:expires_in]
    end
    return data
	end

  def check_user_is_logged_in
  	if current_user.present? 
  		redirect_to root_path, notice: "you are already logged in"
  	end
  end

  def authenticate_user
    if !current_user || current_user.expires_in > DateTime.now.to_i
      redirect_to new_session_path, notice: "Please Login"
    end
  end
end

