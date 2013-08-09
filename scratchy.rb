require 'dcell'

DCell.start :id => "scratchy", :addr => "tcp://127.0.0.1:9002"

itchy_node = DCell::Node["itchy"]

puts "sending message"
puts itchy_node[:itchy].post

