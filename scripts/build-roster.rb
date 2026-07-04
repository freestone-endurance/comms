#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Convert an HL100 registration CSV into a Jekyll roster data file.
# Usage: ruby scripts/build-roster.rb <path-to-csv> <race-slug>
# Writes _data/rosters/<race-slug>.yml, sorted ascending by bib.
#
# Columns are looked up by header name, so column order/extra columns are fine.
# Only rows with Status == "Active" and a non-blank Bib and First Name are kept.
# The form shows first name only.

require "csv"
require "yaml"

csv_path, race = ARGV
unless csv_path && race
  abort "Usage: ruby scripts/build-roster.rb <path-to-csv> <race-slug>"
end

rows = CSV.read(csv_path, headers: true)

runners = rows.filter_map do |row|
  next unless row["Status"]&.strip == "Active"

  bib = row["Bib"]&.strip
  name = row["First Name"]&.strip
  next if bib.nil? || bib.empty? || name.nil? || name.empty?

  { "bib" => Integer(bib, 10), "name" => name }
end

runners.sort_by! { |runner| runner["bib"] }

out_dir = File.join("_data", "rosters")
require "fileutils"
FileUtils.mkdir_p(out_dir)
out_path = File.join(out_dir, "#{race}.yml")
File.write(out_path, YAML.dump(runners))

puts "Wrote #{runners.length} runners to #{out_path}"
