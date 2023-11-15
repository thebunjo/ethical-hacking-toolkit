require 'digest'

puts "Available Hashing Algorithms:"
puts "1. MD5"
puts "2. SHA-1"
puts "3. SHA-256"
puts "4. SHA-384"
puts "5. SHA-512"

begin
  print "Select an algorithm (1-5): "
  choice = gets.chomp.to_i

  unless (1..5).include?(choice)
    raise "Invalid choice. Please select a valid option."
  end

  print "Enter text: "
  text = gets.chomp.to_s

rescue StandardError => e
  puts "Error: #{e.message}"
  exit
end

algorithm = case choice
            when 1
              "MD5"
            when 2
              "SHA1"
            when 3
              "SHA256"
            when 4
              "SHA384"
            when 5
              "SHA512"
            end

hash = Digest::const_get(algorithm).hexdigest(text)

puts "Hash (#{algorithm}): #{hash}"
