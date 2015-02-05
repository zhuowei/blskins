require 'net/http'
require 'json'
require 'base64'

def verify_inpvp(username, password)
	begin
		uri = URI("https://api.inpvp.net/v1/auth/check.json")
		http = Net::HTTP::new(uri.host, uri.port)
		http.use_ssl = true
		req = Net::HTTP::Post.new(uri.request_uri)
		req.body = JSON.dump({"username" => username, "password" => Base64::encode64(password)})
		req["Content-Type"] = "application/json"
		res = http.request(req)
		if res == nil
			return false
		end
		if res.code.to_i >= 400
			return false
		end
		return true
	rescue Exception => e
		puts e.message
		puts e.backtrace.inspect
	end
	return false
end
