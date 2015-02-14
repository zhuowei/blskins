#at_exit {
#	pushsite
#	begin
#		`killall nginx`
#	rescue Errno::ENOENT
#	end
#}

# http://stackoverflow.com/questions/11105556/where-do-i-put-code-in-sinatra-that-i-want-to-execute-when-the-app-is-shutdown

require "sinatra"
require "net/http"
require 'thread'
require_relative "cloner"
require_relative "verify_lbsg"
require_relative "verify_epicmc"
require_relative "verify_inpvp"
require_relative "writecape"

#$repo_conch = Mutex.new

def startnginx()
	if ENV["PORT"] == nil
		ENV["PORT"] = "4567"
	end
	proc = Process.spawn("./startnginx.sh")
	Process.detach(proc)
end

#startnginx

#`rm -rf blskins`
#clonesite
#`mkdir -p blskins/capes/`

$needs_push = false

#Thread.new {
#	while true
#		if $needs_push
#			pushsite
#			$needs_push = false
#		end
#		sleep 60*3
#	end
#}

get '/' do
	forwarded_proto = env["HTTP_X_FORWARDED_PROTO"]
	if forwarded_proto != nil and forwarded_proto != "https"
		redirect("https://blskins.herokuapp.com")
		return
	end
	send_file "public/index.html"
end

post '/upload_lbsg' do
	if not verify_lbsg(params[:name], params[:password])
		redirect("/lbsg_err.html")
		return
	end
	upload_impl params
end

post '/upload_epicmc' do
	if not verify_epicmc(params[:name], params[:password])
		redirect("/epicmc_err.html")
		return
	end
	upload_impl params
end

post '/upload_inpvp' do
	if not verify_inpvp(params[:name], params[:password])
		redirect("/inpvp_err.html")
		return
	end
	upload_impl params
end

def upload_impl(params)
	username = params[:name].downcase()
	if username.length < 1 or /[^a-zA-Z0-9_]/.match(username)
		redirect("/nameerr.html")
		return
	end
	fileobj = params[:file]
	if fileobj == nil
		redirect("/fileerr.html")
		return
	end
	file = fileobj[:filename]
	#if file.length < 1 or not file.downcase().end_with?(".png")
	#	redirect("/fileerr.html")
	#	return
	#end
	filename = "blskins/" + username + ".png"
	if params[:cape] == "1"
		filename = "blskins/capes/" + username + ".png"
		writecape(fileobj[:tempfile], filename)
	else
		File.copy_stream(fileobj[:tempfile], filename)
	end
	$needs_push = true
	redirect("/success.html")
end

post '/upload_desktop' do
	username = params[:name].downcase()
	if username.length < 1 or /[^a-zA-Z0-9_]/.match(username)
		redirect("/nameerr.html")
		return
	end
	response = Net::HTTP::get_response(URI("http://s3.amazonaws.com/MinecraftSkins/" + params[:name] + ".png"))
	if response.code.to_i >= 400
		redirect("/nameerr.html")
	end
	File.open("blskins/" + username + ".png", "wb") do |file|
		file.write(response.body)
	end
	$needs_push = true
	redirect("/success.html")
end

get '/blskins/:name' do
	file = 'blskins/' + params[:name]
	if File.exist? file
		send_file(file)
	else
		halt 404
	end
end
