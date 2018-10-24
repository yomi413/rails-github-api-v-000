class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    resp = Faraday.post("https://github.com/login/oauth/access_token") do |req|
      # req.body = { 'client_id': ENV['GITHUB_CLIENT_ID'], 'client_secret': ENV['GITHUB_CLIENT_SECRET'], 'code': 'authorization_code' }
      req.headers['Accept'] = 'application/json'
      req.params['client_id'] = ENV['GITHUB_CLIENT_ID']
      req.params['client_secret'] = ENV['GITHUB_CLIENT_SECRET']
      # req.params['grant_type'] = 'authorization_code'
      # req.params['redirect_uri'] = "https://localhost:3000/auth"
      req.params['code'] = params[:code]
    end

    body = JSON.parse(resp.body)
    session[:token] = body["access_token"]
    redirect_to root_path
  end
end
