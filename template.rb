# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm -f public/javascripts/*"
run "rm log/*.log"

# Download jQuery
run "curl -L http://code.jquery.com/jquery-1.4.2.min.js > public/javascripts/jquery.js"

# Make database.yml for distribution use
run "mv config/database.yml config/database.yml.example"

# Create staging environment
run "cp config/environments/production.rb config/environments/staging.rb"

# Bundle
file "Gemfile", <<-END
source :gemcutter
gem 'rails', '~> 2.3.8'
END
run "bundle install vendor/bundle"

# Set up git repository
git :init

# Set up .gitignore
run "touch tmp/.gitignore log/.gitignore vendor/bundle/.gitignore"
file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
tmp/restart.txt
public/system/**/*
.bundle/environment.rb
vendor/bundle/specifications
vendor/bundle/docs
vendor/bundle/bin
vendor/bundle/cache
END

# Commit all work
git :add => "."
git :commit => "-m 'Initial commit'"

# Done
puts "SUCCESS!"