class DummyfilesController < ApplicationController
  def index
    @dummyfiles = Dummyfile.all
  end

  def show
  end

  def new
    @dummyfile = Dummyfile.new
  end
  
  def execute
    @dummyfile = Dummyfile.new(params[:dummyfile])
    if @dummyfile.save
      @dummyfile.convert
      flash[:notice] = 'Your file has been generated.'
      redirect_to :action => 'index'
    else
      flash[:notice] = 'There was a problem generating your file. Please try again.'
      redirect_to :action => 'index'
    end
  end
end
