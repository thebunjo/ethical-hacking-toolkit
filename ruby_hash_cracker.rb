threads = []

if ARGV.length != 3
  puts "Usage example: ruby ruby_hash_cracker.rb md5 wordlist.txt hash"
  exit(1)
end

require 'digest'

$algorithm = ARGV[0].to_s.upcase
$pass_path = ARGV[1].to_s
$hash = ARGV[2].to_s

if !File.exist?($pass_path)
  puts "Password dont found."
  exit(1)
end

found = false

def crack
  File.open($pass_path, "r") do |file|
      puts "Cracking..."
      file.each_line do |line|
        pass = line.chomp
        try_pass = Digest.const_get($algorithm).hexdigest(pass)
        if try_pass == $hash
          puts "Cracked: #{$hash}:#{pass}"
          found = true
          break
        end
      end
  end
end

threads << Thread.new do
  crack
end

threads.each(&:join)