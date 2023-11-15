require 'socket'

puts "Usage: ruby ruby_banner_grabber.rb google.com 80."

host = ARGV[0]
port = ARGV[1]

sock = TCPSocket.new(host, port)
sock.puts("GET / HTTP/1.1\r\n\r\n")

while line = sock.gets do
  puts line.chop
end
sock.close