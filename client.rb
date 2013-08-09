require 'nestful'

puts Nestful.get('http://localhost:8080/mailbox/post?message=foobar')
