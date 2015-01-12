require "sinatra"
require_relative "cloner"
require_relative "verify_lbsg"

`rm -rf blskins`
clonesite

get '/' do
	forwarded_proto = env["HTTP_X_FORWARDED_PROTO"]
	if forwarded_proto != nil and forward_proto != "https"
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
	pushsite
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
