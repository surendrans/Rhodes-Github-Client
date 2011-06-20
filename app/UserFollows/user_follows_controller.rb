require 'rho/rhocontroller'
require 'helpers/browser_helper'

class UserFollowsController < Rho::RhoController
  include BrowserHelper
  
  
    
def following
  @user = User.find(:all).first
  my_repo_url = "https://github.com/api/v2/json/repos/show/" + @user.username
  Rho::AsyncHttp.get(
       :url => my_repo_url,
       :callback => (url_for :action => :my_repo_callback),
       :callback_param => "" )
  render :action => :wait
end

    
def my_followers
  @user = User.find(:all).first
  my_repo_url = "https://github.com/api/v2/json/user/show/" +  @user.username + "/followers" 
  Rho::AsyncHttp.get(
       :url => my_repo_url,
       :callback => (url_for :action => :my_followers_callback),
       :callback_param => "" )
  render :action => :wait
end

end
  