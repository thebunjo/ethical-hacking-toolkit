require 'whois'

puts "Enter URL:"
url = gets.chomp

begin
  info = Whois.whois(url)
  puts info
rescue Whois::Error => e
  puts "An error occurred: #{e.message}"
end
