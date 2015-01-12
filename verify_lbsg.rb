require 'net/http'
require 'json'
require 'base64'

def verify_lbsg(username, password)
	begin
		
		res = Net::HTTP::post_form(URI("http://account.lbsg.net/newstats/settings.php"),
			{:username => username, :password => Base64::encode64(password)})
		if res == nil
			return false
		end
		response = JSON::parse(res.body())
		return (response["error"] == false)
	rescue Exception => e
		puts e.message
		puts e.backtrace.inspect
	end
	return false
end
