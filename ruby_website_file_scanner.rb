require 'net/http'

def scan(url, file)
  uri = URI.parse(url + file)

  scan_thread = Thread.new do
    response = Net::HTTP.get_response(uri)

    case response.code
    when "200"
      puts "[+] Found: #{uri}"
    when "403"
      puts "[?] Forbidden: #{uri}"
    when "400"
      puts "[-] Bad request: #{uri}"
    when "401"
      puts "[-] Unauthorized: #{uri}"
    when "500"
      puts "[-] Internal server error: #{uri}"
    when "204"
      puts "[-] No Content"
    when "404"
      puts "[-] Not found: #{uri}"
    end
  end

  scan_thread # İş parçacığını döndürün.
end

threads = []
url = ARGV[0].to_s
files = ["/index.html", "/secret_file.txt", "/robots.txt", "/humans.txt", "/sitemap.xml", "/favicon.ico", "/apple-touch-icon.png", "/manifest.json"]
files.each { |file| threads << scan(url, file) }
threads.each(&:join)
