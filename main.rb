require "sinatra"
require_relative "cloner"

clonesite

get '/' do
	send_file "public/index.html"
end

post '/upload' do
	username = params[:name].downcase()
	if username.length < 1 or /[^a-zA-Z0-9_]/.match(username)
		redirect("/nameerr.html")
		return
	end
	fileobj = params[:file]
	file = fileobj[:filename]
	if file == nil or file.length < 1 or not file.downcase().end_with?(".png")
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
