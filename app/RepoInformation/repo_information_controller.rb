require 'rho/rhocontroller'
require 'helpers/browser_helper'

class RepoInformationController < Rho::RhoController
  include BrowserHelper

  #GET /RepoInformation
  def index
    @repo_name = @params[:name]
    @repoinformations = RepoInformation.find(:all)
    render :back => '/app'
  end

  # GET /RepoInformation/{1}
  def show
    @repoinformation = RepoInformation.find(@params['id'])
    if @repoinformation
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /RepoInformation/new
  def new
    @repoinformation = RepoInformation.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /RepoInformation/{1}/edit
  def edit
    @repoinformation = RepoInformation.find(@params['id'])
    if @repoinformation
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /RepoInformation/create
  def create
    @repoinformation = RepoInformation.create(@params['repoinformation'])
    redirect :action => :index
  end

  # POST /RepoInformation/{1}/update
  def update
    @repoinformation = RepoInformation.find(@params['id'])
    @repoinformation.update_attributes(@params['repoinformation']) if @repoinformation
    redirect :action => :index
  end

  # POST /RepoInformation/{1}/delete
  def delete
    @repoinformation = RepoInformation.find(@params['id'])
    @repoinformation.destroy if @repoinformation
    redirect :action => :index  end
    
    def contributors
      @user = User.find(:all).first
      @base_url = "https://github.com/api/v2/json/"
      repo_con_url = @base_url + "repos/show/" + @user.username + "/" + @params["repo_name"] + "/contributors"
      p "calling repo url#{repo_url}--------------------"
      Rho::AsyncHttp.get(
       :url => repo_con_url,
       :callback => (url_for :action => :repo__con_callback),
       :callback_param => "" )
      render :action => "wait"
    end
    
    def repo__con_callback
      if @params['status'] != 'ok'
        @@error_params = @params
        WebView.navigate ( url_for :action => :show_error)        
  else
        @@get_result = @params['body']['contributors']
        WebView.navigate ( url_for :action => :show_contributors)
  end
    end
    
    def show_contributors
       render :action => :contributors
    end
    def get_result
      @@get_result
    end
end
