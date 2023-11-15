require 'socket'

print "Enter a hostname (e.g., www.example.com): "
hostname = gets.chomp

begin
  ip_address = Socket.getaddrinfo(hostname, nil)[0][3]
  puts "IP Address for #{hostname}: #{ip_address}"
rescue SocketError => e
  puts "Error: #{e}"
end