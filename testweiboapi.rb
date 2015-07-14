# encoding: utf-8
require 'weibo_2'
require 'net/http'
require 'net/https'
require 'uri'

WeiboOAuth2::Config.api_key = 2824644604
WeiboOAuth2::Config.api_secret = "9f6cf05902d196631547a5dc0566152b"
WeiboOAuth2::Config.redirect_uri ="http://www.baidu.com"

client = WeiboOAuth2::Client.new
client.authorize_url
puts client.authorize_url

code = gets
puts code.to_s
#===============
access_token = client.auth_code.get_token(code.to_s)

uid = access_token.params["uid"]
access_token = access_token.token
expires_at = access_token.expires_at
puts access_token.inspect
@user = client.users.show_by_uid(session[:uid].to_i)

# # get '/' do
# #   client = WeiboOAuth2::Client.new
# #   if session[:access_token] && !client.authorized?
# #     token = client.get_token_from_hash({:access_token => session[:access_token], :expires_at => session[:expires_at]})
# #     p "*" * 80 + "validated"
# #     p token.inspect
# #     p token.validated?
# #
# #     unless token.validated?
# #       reset_session
# #       redirect '/connect'
# #       return
# #     end
# #   end
# #   if session[:uid]
# #     @user = client.users.show_by_uid(session[:uid])
# #     @statuses = client.statuses
# #   end
# #   haml :index
# # end
#
# get '/connect' do
#   client = WeiboOAuth2::Client.new
#   redirect client.authorize_url
# end
#
# get '/callback' do
#
#   redirect '/'
# end
#
# get '/logout' do
#   reset_session
#   redirect '/'
# end
#
# get '/screen.css' do
#   content_type 'text/css'
#   sass :screen
# end
#
# post '/update' do
#   client = WeiboOAuth2::Client.new
#   client.get_token_from_hash({:access_token => session[:access_token], :expires_at => session[:expires_at]})
#   statuses = client.statuses
#
#   unless params[:file] && (pic = params[:file].delete(:tempfile))
#     statuses.update(params[:status])
#   else
#     status = params[:status] || '图片'
#     statuses.upload(status, pic, params[:file])
#   end
#
#   redirect '/'
# end
#
# helpers do
#   def reset_session
#     session[:uid] = nil
#     session[:access_token] = nil
#     session[:expires_at] = nil
#   end
# end