# Blskins server source

The source for the serverside portion of the former BlockLauncher skin repository.

This is now completely useless since BlockLauncher no longer loads skins from repositories; it's open sourced for historical interest. Or something.

A Sinatra application handles the uploads, and writes them to a directory; Nginx then serves the static skins. In production, CloudFlare is deployed to further cache skins, and a Heroku application proxies to the production server (since I needed Heroku's SSL support)

Licensed under the 3-clause BSD license: see LICENSE
