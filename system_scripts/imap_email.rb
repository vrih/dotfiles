#!/usr/bin/env ruby
require 'net/imap'

server = ENV['IMAP_SERVER']
username = ENV['IMAP_USERNAME']
password = ENV['IMAP_PASSWORD']

imap = Net::IMAP.new(server, port: 993, ssl: true,)
imap.login(username, password)

mailbox_list = imap.list("", "*").map{|mb| mb.name}

total_unread = mailbox_list.inject(0) {|sum, n| sum + (n != "Trash" ? imap.status(n, ['UNSEEN'])['UNSEEN'].to_int : 0)}
p total_unread
p total_unread
imap.logout
imap.disconnect
