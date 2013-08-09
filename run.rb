require 'net/http/server'
require 'pp'
require 'debugger'
require 'rack'

class World
  class Mailbox
    def initialize(options = {})
      @messages = []
    end

    def self.post(message = {})
      @messages << message
      pp "New Message: #{message}"
      true
    end
  end

  def initialize(options = {})
    @mailbox = Mailbox.new
  end

  def start
    Net::HTTP::Server.run(:port => 8080) do |request, stream|
      begin
        pp request
        paths = request[:uri][:path].to_s.split("/")
        recipient = paths[1] # cdr, or rest
        message = paths[2]
        params = Rack::Utils.parse_nested_query(request[:uri][:query].to_s)
        pp "Recipient: #{recipient}"
        pp "Message name: #{message}"
        pp "Params: #{params}"
        if methods.include?(recipient.to_sym)
          pp "Recipient exists, attempting to send message..."
          begin
            result = self.send(message.to_sym(params))
            pp "success: #{result.to_s}"
            [200, {'Content-Type' => 'text/plain'}, [result.to_s]]
          rescue => e
            pp "Responding with error: #{e.to_s}"
            [500, {'Content-Type' => 'text/plain'}, [e.to_s]]
          end
        else
          [404, {'Content-Type' => 'text/plain'}, ['No such recipient.']]
        end
      rescue => e
        pp "Error occurred: #{e}"
        [500, {'Content-Type' => 'text/plain'}, [e]]
      end
    end
  end

  def mailbox
    @mailbox
  end
end

w = World.new
w.start


