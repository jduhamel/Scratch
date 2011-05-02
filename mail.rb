require 'appscript'
require 'pp'

include Appscript

mail = app('Mail')

mailboxes = mail.mailboxes.get
accounts = mail.accounts.get


archive_folder = mail.accounts["KVH"].mailboxes["Archive"]
messages = archive_folder.messages.get
messages.each do |m|
  puts "#{m.sender.get} Subject - #{m.subject.get}"
end
