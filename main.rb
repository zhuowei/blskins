require "sinatra"
require_relative "cloner"

clonesite

get '/' do
	send_file "public/index.html"
end

post '/upload' do
	p "Upload!"
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
	File.rename(fileobj[:tempfile], "blskins/" + username + ".png")
	pushsite
	redirect("/success.html")
end
