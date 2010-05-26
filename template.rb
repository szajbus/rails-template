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

file "config/preinitializer.rb", <<-END
begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
  raise RuntimeError, "Your bundler version is too old." +
    "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end
END

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

# Copy database.yml.example to database.yml
run "cp config/database.yml.example config/database.yml"

# Done
puts "SUCCESS!"
