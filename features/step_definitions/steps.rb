Given /^OUTPUT is printed/ do
    stdoutOutput = all_commands.map { |c| c.stdout }.join("\n").strip
    if stdoutOutput != ""
        log "STDOUT>>>"
        log stdoutOutput
        log "<<<STDOUT"
    else
        log "STDOUT is EMPTY"
    end
    stderrOutput = all_commands.map { |c| c.stderr }.join("\n").strip
    if stderrOutput != ""
        log "STDERR>>>"
        log stderrOutput
        log "<<<STDERR"
    else
        log "STDERR is EMPTY"
    end
end
Before do
end

Given /^the output should contain PWD$/ do 
	if @dirs == nil then
		@dirs = ["tmp", "aruba"]
	end	
	#puts ENV['PWD']
	#puts ENV['HOME']
	#puts @dirs.join("/")
	#step "the output should match /" + Regexp.escape(ENV['PWD']) + "/"
	step "the output should contain \"" +  ENV['PWD'] + "/" + @dirs.join("/") + "\""
end

Given /^the output should contain HOME$/ do 
	puts "The home directory is #{ENV['HOME']}"
	#puts @dirs.join("/")
	#step "the output should match /" + Regexp.escape(ENV['HOME']) + "$/"
	step "the output should contain \"" +  ENV['HOME'] + "\n" + "\""
	#step "the output should not contain \"" +  ENV['HOME'] + "/" + "\""
end

Given /^the output should contain the host name$/ do
	#puts "The Host Name here is " + ENV['PWD']
	#step "the output should match /" + Regexp.escape(ENV['PWD']) + "/"
	#step "the output should contain \"" + #{str} + " " + ENV['HOSTNAME'] + "\""
	#step "the output should contain \"icarus\""
	@host = `hostname`
	puts "The Host Name here is " + @host 
	step "the output should contain \"" + @host + "\""
end

Given /^the output should contain the pid\/ppid$/ do
	@mypid = $?.pid
	@myppid = Process.pid
	puts "The pid is " + "#{@mypid}" + " and the PPID is " + "#{@myppid}"
	step "the output should contain \"" + "#{@mypid}/#{@myppid}" + "\""
end

Given /^there is only one (.*) running$/ do |pgm|
	@cnt = `ps --no-header -C #{pgm} | wc -l`
	if @cnt != "1" 
		@psout = `ps -C #{pgm}`
		raise "There are more than one #{pgm} programs running.\n#{@psout}"
	end
end

Given /^(.*) points are awarded/ do |points|
	#puts "#{points} points are now awarded!!!"
	$total_points += points.to_i
end

Given /^dot is replaced with PWD\/(.*)$/ do |outputfile|
	step "the output should contain \"copy #{outputfile} #{ENV['PWD']}\/#{File.join(@dirs)}\/#{outputfile}\""
end

Given /^timeout is increased by (.*) seconds$/ do |seconds|
	if @aruba_timeout_seconds  
		@aruba_timeout_seconds += seconds.to_i
	else
		puts "aruba_timeout_seconds is NIL!"
	end
end

Given /^timeout is decreased by (.*) seconds$/ do |seconds|
	if @aruba_timeout_seconds
		@aruba_timeout_seconds -= seconds.to_i
	else
		puts "aruba_timeout_seconds is NIL!"
	end
end

