class HomeController < ApplicationController
  def index
    @users = User.all
  end
  
  def create
    @user = User.new
  end
  
  def show
    @user = User.params([:id])
  end
  
  #def delete
  #  @user = User.params([:id]).delete(:method => delete)
  #end
end
