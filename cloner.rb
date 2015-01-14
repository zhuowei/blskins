def clonesite()
	if File.exist? "no-download"
		p "Downloading disabled"
		`mkdir blskins`
		return
	end
	sitepath = "git@bitbucket.org:blskins/blskins.git"
	wd = ENV["PWD"]
	ENV["GIT_SSH"] = wd + "/ssh-wrap"
	`git clone #{sitepath} blskins`
	`git -C blskins config user.name blskins`
	`git -C blskins config user.email example@example.com`
end

def pushsite()
	if File.exist? "no-upload"
		p "Uploading disabled"
		return
	end
	wd = ENV["PWD"]
	ENV["GIT_SSH"] = wd + "/ssh-wrap"
	`git -C blskins add .`
	`git -C blskins commit -m update`
	`git -C blskins fetch origin master`
	`git -C blskins merge origin/master`
	`git -C blskins push -f origin master`
end
