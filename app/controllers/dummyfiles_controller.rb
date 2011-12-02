class DummyfilesController < ApplicationController  
  def create
    @dummyfile     = Dummyfile.new(params[:dummyfile])
    @filetype      = params[:filetype]
    @size          = params[:size]
    @size_in_bytes = @size.to_i * (1024 * 1024)
    
    if @dummyfile.save
      if @filetype == "bmp" or @filetype == "jpeg" or @filetype == "tif" or @filetype == "png"  or @filetype == "gif" or @filetype == "tga"
        puts "controller image loop"
        @dummyfile.convert_image
        @convert_method = convert_image
      
      elsif @filetype == "mp3" or @filetype == "ogg" or @filetype == "wma" or @filetype == "aiff"  or @filetype == "wav"
        puts "controller audio loop"
        @dummyfile.convert_audio
      
      elsif @filetype == "mov" or @filetype == "avi" or @filetype == "mpg" or @filetype == "mpeg" or @filetype == "mp4"  or @filetype == "mkv"
        puts "controller video loop"
        @dummyfile.convert
      
      elsif @filetype == "doc" or @filetype == "docx"
        puts "controller doc loop"
        @dummyfile.convert_doc
      
      elsif @filetype == "pdf"
        puts "controller pdf loop"
        @dummyfile.convert_pdf
      end
      
      if @dummyfile.state == "converted"
      puts "dummyfile state is converted...do the dd here #{@size_in_bytes.is_a?}"
      #`dd if=/dev/zero of=/Users/cwade/Sites/dummygen/public/generated/public_filename.#{@dummyfile.id}.#{@filetype} bs=1 count=0 seek=#{@size_in_bytes}`
      `dd if=/dev/zero of=/Users/chriswade/Nerdery/vagrant/shared/DummyFileGenerator/public/generated/public_filename.#{@dummyfile.id}.#{@filetype} bs=1 count=0 seek=#{@size_in_bytes}`
      end
      
      flash[:notice] = 'Your ' + @size + 'MB ' + @filetype.upcase + ' file has been generated. ' + ' Bytes: ' + @size_in_bytes.to_s
      puts "Success flash notice here"
      redirect_to :action => 'index'
    else
      flash[:notice] = 'There was a problem generating your file. Please try again.'
      redirect_to :action => 'index'
    end
  end
  
  def index
    @dummyfiles = Dummyfile.all
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
