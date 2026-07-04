source "https://rubygems.org"

# Run Jekyll with `bundle exec jekyll serve`. Bump the version here and run
# `bundle update jekyll` to upgrade.
gem "jekyll", "~> 4.4"

# Local dev server (no longer bundled with Ruby 3.0+).
gem "webrick", "~> 1.9"

# Plugins
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17"
end

# Windows and JRuby do not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance booster for watching directories on Windows.
gem "wdm", "~> 0.2", :platforms => [:mingw, :x64_mingw, :mswin]
