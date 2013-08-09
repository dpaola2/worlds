require 'dcell'

DCell.start :id => "itchy", :addr => "tcp://127.0.0.1:9001"

class Itchy
  include Celluloid

  def initialize
    puts "Ready!"
    @messages = []
  end

  def post
    puts "new message!"
    "result of posting a new message"
  end
end

Itchy.supervise_as :itchy
sleep

