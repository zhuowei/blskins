require 'net/http'
require 'json'
require 'base64'

def verify_epicmc(username, password)
	begin
		uri = URI("https://epicmc.us/login.php")
		http = Net::HTTP::new(uri.host, uri.port)
		http.use_ssl = true
		req = Net::HTTP::Post.new(uri.request_uri)
		req.set_form_data({:username => username, :password => password, :submit => "LOGIN"})
		res = http.request(req)
		if res == nil
			return false
		end
		if res.code.to_i >= 400
			return false
		end
		body = res.body
		return (not body.include?("CHECK YOUR PASSWORD."))
	rescue Exception => e
		puts e.message
		puts e.backtrace.inspect
	end
	return false
end
