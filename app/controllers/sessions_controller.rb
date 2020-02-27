class SessionsController < ApplicationController
  before_action :check_user_is_logged_in, only: [:create, :new]

  def new
    @session = Session.new
  end

  def create
    api_session = Session.new(params.require(:session).permit(:username, :password))
    result = api_session.create
    session[:user_information] = extract_user_information(result)
    session[:user_information][:email] = params[:session][:username]
    flash[:success] = 'You have successfully signed in!'
    redirect_to resolve_landing_path
  rescue RestClient::Unauthorized
    @session = Session.new
    flash.now[:alert] = 'Invalid email or password'
    render :new
  end

  def destroy
    Session.destroy(token: session[:user_information]["access_token"])
    session.delete :user_information
    flash[:success] = 'You have successfully signed out!'
    redirect_to root_path
  end

  private

  # Resolves if user should be redirected to a previously requested page or to home.
  def resolve_landing_path
    params[:return_to] || root_path
  end
end
