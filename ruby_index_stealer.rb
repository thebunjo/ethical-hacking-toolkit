require 'net/http'

print "Target (ex: http://url.com/): "
url = gets.chomp

uri = URI(url)
response = Net::HTTP.get_response(uri)

if response.code == "200"
  File.open('index.html', 'w') do |file|
    file.write(response.body)
    puts response.body
  end
end