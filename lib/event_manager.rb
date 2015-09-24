require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "a689a92ea3384be7a523082e7ee8ea95"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode zipcode
	Sunlight::Congress::Legislator.by_zipcode(zipcode) 
end
	
puts "EventManager initialized."

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.html"
erb_template = ERB.new template_letter

contents.each do |row|
	id = row[0]
	name = row[:first_name]

	zipcode = clean_zipcode(row[:zipcode])

	legislators = legislators_by_zipcode(zipcode)

	Dir.mkdir("output") unless Dir.exists? "output"

	filename = "output/thanks_#{id}.html"

	File.open(filename, 'w') do |file|
		file.puts form_letter
	end
end