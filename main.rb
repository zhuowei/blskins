at_exit {
	pushsite
	begin
		`killall nginx`
	rescue Errno::ENOENT
	end
}

# http://stackoverflow.com/questions/11105556/where-do-i-put-code-in-sinatra-that-i-want-to-execute-when-the-app-is-shutdown

require "sinatra"
require_relative "cloner"
require_relative "verify_lbsg"

def startnginx()
	if ENV["PORT"] == nil
		ENV["PORT"] = "4567"
	end
	proc = Process.spawn("./startnginx.sh")
	Process.detach(proc)
end

startnginx

`rm -rf blskins`
clonesite

$needs_push = false

Thread.new {
	while true
		if $needs_push
			pushsite
			$needs_push = false
		end
		sleep 60*5
	end
}

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
	if file.length < 1 or not file.downcase().end_with?(".png")
		redirect("/fileerr.html")
		return
	end
	File.copy_stream(fileobj[:tempfile], "blskins/" + username + ".png")
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
