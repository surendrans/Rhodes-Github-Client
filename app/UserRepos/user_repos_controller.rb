require 'rho/rhocontroller'
require 'helpers/browser_helper'

class UserReposController < Rho::RhoController
  include BrowserHelper
  

  
def my_repos
  @user = User.find(:all).first
  my_repo_url = "https://github.com/api/v2/json/repos/show/" + @user.username
  Rho::AsyncHttp.get(
       :url => my_repo_url,
       :callback => (url_for :action => :my_repo_callback),
       :callback_param => "" )
  render :action => :wait
end

def forked_repos
  @user = User.find(:all).first
  my_repo_url = "https://github.com/api/v2/json/repos/show/" + @user.username
  Rho::AsyncHttp.get(
       :url => my_repo_url,
       :callback => (url_for :action => :forked_repo_callback),
       :callback_param => "" )
  render :action => :wait
end

def watching_repos
@user = User.find(:all).first
  my_repo_url = "https://github.com/api/v2/json/repos/watched/" + @user.username
  Rho::AsyncHttp.get(
       :url => my_repo_url,
       :callback => (url_for :action => :watching_repo_callback),
       :callback_param => "" )
  render :action => :wait
end

def my_repo_callback
  
  if @params['status'] != 'ok'
        @@error_params = @params
        WebView.navigate ( url_for :action => :show_error )        
  else
        @@get_result = @params['body']
        WebView.navigate ( url_for :action => :show_result )
  end
  
end
  
def forked_repo_callback
   if @params['status'] != 'ok'
       @@error_params = @params
        WebView.navigate ( url_for :action => :show_error )        
  else
        @@get_result = @params['body']['repositories']
        @@get_result = @@get_result.collect {|repo| repo if repo["fork"] }.compact
        WebView.navigate ( url_for :action => :show_forked_repo_result )
  end
end

def watching_repo_callback
   if @params['status'] != 'ok'
       @@error_params = @params
        WebView.navigate ( url_for :action => :show_error )        
  else
        @@get_result = @params['body']['repositories']
        @@get_result = @@get_result.collect {|repo| repo if repo["fork"] }.compact
        WebView.navigate ( url_for :action => :show_watching_repo_result )
  end
end

  def show_error
  end
  
  def show_result
    render :action => :my_repos, :back => '/app/UserRepos'
  end
  
  
def get_res
  @@get_result
end


def show_forked_repo_result
    render :action => :forked_repos, :back => url_for(:action => :index)
end
def show_watching_repo_result
    render :action => :watching_repos, :back => url_for(:action => :index)
end
  
end