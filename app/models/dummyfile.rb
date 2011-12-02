class Dummyfile < ActiveRecord::Base
  attr_accessible :filetype, :size, :executable, :filename, :state
  #validates_presence_of :filetype
  #validates_length_of :size, :maximum => 3
  #acts as state machine plugin
  acts_as_state_machine :initial => :pending
  state :pending
  state :converting
  state :converted#, :enter => :set_new_filename
  state :error

  event :convert do
    transitions :from => :pending, :to => :converting
  end

  event :converted do
    transitions :from => :converting, :to => :converted
  end

  event :failure do
    transitions :from => :converting, :to => :error
  end
  
  # This method is called from the controller and takes care of the converting
  def convert
    self.convert!
    success = system(convert_command)
    if success && $?.exitstatus == 0
      #success = system(dd_command)
      self.converted!
    else
      self.failure!
    end
  end

#  protected
  
  def convert_command
    puts "convert_command called"
  #construct new file extension
    @flv =  "public_filename" + "." + id.to_s + "." + filetype.to_s
  
  #build the command to execute ffmpeg
    command = <<-end_command
     ffmpeg -i /Users/cwade/Sites/dummygen/public/templates/video.mp4 -ar 22050 -ab 32 -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y /Users/cwade/Sites/dummygen/public/generated/#{@flv}
    end_command
    
    logger.debug "Generating...command: " + command
    command
    #ffmpeg -i /Users/chriswade/Nerdery/vagrant/shared/DummyFileGenerator/public/templates/video.mp4 -ar 22050 -ab 32 -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y /Users/chriswade/Nerdery/vagrant/shared/DummyFileGenerator/public/generated/#{@flv}
    #ffmpeg -i #{ RAILS_ROOT + '/public' + public_filename }  -ar 22050 -ab 32 -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y #{ RAILS_ROOT + '/public' + public_filename + flv }
    # && dd if=/dev/zero of=/Users/cwade/Sites/dummygen/public/generated/#{flv} bs=1 count=0 seek=500
  end
  
  #def dd_command
  #  puts "dd_command called"
  #  command = <<-end_command
  #   dd if=/dev/zero of=/Users/cwade/Sites/dummygen/public/generated/#{@flv} bs=1 count=0 seek=#{@size_in_bytes.to_s}
  #  end_command
  #  
  #  logger.debug "Adding payload...command: " + command
  #  command
  #end
  #def convert_audio
  #  puts "convert_audio called"
  ##construct new file extension
  #  flv =  "public_filename" + "." + id.to_s + ".avi"
  #
  ##build the command to execute ffmpeg
  #  command = <<-end_command
  #   ffmpeg -i /Users/cwade/Sites/dummygen/public/templates/video.mp4 -ar 22050 -ab 32 -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y /Users/cwade/Sites/dummygen/public/generated/#{flv} && dd if=/dev/zero of=/Users/cwade/Sites/dummygen/public/generated#{flv} bs=1 count=0 seek=500
  #   
  #  end_command
  #  
  #  logger.debug "Creating or generating file...command: " + command
  #  command
  #  #     ffmpeg -i #{ RAILS_ROOT + '/public' + public_filename }  -ar 22050 -ab 32 -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y #{ RAILS_ROOT + '/public' + public_filename + flv }
  #end
  # This updates the stored filename with the new flash video file
  #def set_new_filename
  #  update_attribute(:filename, "#{filename}.#{id}.flv")
  #  update_attribute(:content_type, "application/x-flash-video")
  #end
end
