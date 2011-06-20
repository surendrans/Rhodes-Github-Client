require 'rho/rhocontroller'
require 'helpers/browser_helper'

class UserController < Rho::RhoController
  include BrowserHelper

def create
  User.delete_all
  username =   @params['user']['username']
  user_search_url = "https://github.com/api/v2/json/user/show/" + username
  
  Rho::AsyncHttp.get(
       :url => user_search_url,
       :callback => (url_for :action => :get_user_info),
       :callback_param => "" )
  
  #user_details = Rho::AsyncHttp.get(:url => user_search_url, :callback => (url_for :get_user_info), :callback_param => "username=#{username}")
   render :action => :wait
  end

  def delete
    @user = User.find(@params['id'])
    @user.destroy if @user
    redirect :action => :index 
  end
  
 def listing
    @user = User.find(:all).first
 end
  
  def get_error
    @@error_params
  end
  
  def get_user_info
    p @caller_request,"caller ---------------------"
    p username,"=========================username"
    if @params['status'] != 'ok'
       @@error_params = @params
        WebView.navigate ( url_for :action => :show_error )        
  else
       @user = User.create(username)
        WebView.navigate ( url_for :action => :show_listing )
  end
  end
  
  def show_listing
    render :action => :listing
  end
end
