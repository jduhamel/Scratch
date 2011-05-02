#!/usr/bin/env ruby

require 'rubygems'
require 'appscript'
require "osax"

# let the user choose the destination
sa = OSAX.osax('StandardAdditions')
default = Appscript.app("Finder").Finder_windows[1].target.get(:result_type => :alias)
destination_folder = sa.choose_folder(:with_prompt => "Choose destination:", :default_location => default)

app = Appscript.app('Mail.app')
growl = Appscript.app('GrowlHelperApp.app')

selection = app.selection.get

# loop through all selected messages
selection.each do |message|

  # prefix the attachment with its date in yyyy-mm-dd format (so they're listed chronologically in the Finder)
  formatted_date = message.date_received.get.strftime("%Y-%m-%d")

  # loop through the message's attachments
  message.mail_attachments.get.each do |attachment|
    attachment_name = attachment.name.get
    path = File.join(destination_folder.to_s, formatted_date + " " + attachment_name)

    # get rid of any colons
    path.gsub!(/:/, "-")

    # check if it's already there
    if File.exists?(path)
      puts %Q!File "#{attachment_name}" already exists.!
      next
    end

    # save the attachment
    begin
      app.save( attachment, :in => path )
    rescue Exception => e
      puts %Q!Couldn't save attachment from message "#{message.subject.get}" : #{e}!
    end

  end
end
