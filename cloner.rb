def clonesite()
	wd = ENV["PWD"]
	ENV["GIT_SSH"] = wd + "/ssh-wrap"
	`git clone git@github.com:blskins/blskins.github.io.git blskins`
	`git -C blskins config user.name blskins`
	`git -C blskins config user.email example@example.com`
end

def pushsite()
	wd = ENV["PWD"]
	ENV["GIT_SSH"] = wd + "/ssh-wrap"
	`git -C blskins add .`
	`git -C blskins commit -m update`
	`git -C blskins push -f origin master`
end
