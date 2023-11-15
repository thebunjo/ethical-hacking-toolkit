list = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['!', '@', '#', '$', '%', '^', '&', '*']

print "Enter the length of the password: "
generate_thread = Thread.new do
  password_length = gets.chomp.to_i
  generated_password = Array.new(password_length) {list.sample}.join
  puts "Generated password: #{generated_password}"
end

generate_thread.join