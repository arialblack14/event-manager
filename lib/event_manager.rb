require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "a689a92ea3384be7a523082e7ee8ea95"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, "0")[0..4]
end

def clean_phone_number(number)
	str_number = number.to_s.length
	if str_number == 10
		number
	elsif !str_number.between? 10, 11
		number = "00000000000"
	elsif str_number > 10
		number.to_s.split("").first == 1 ? number.to_s.split("")[1..-1].join : "0000000000"
	end
end

def legislators_by_zipcode zipcode
	Sunlight::Congress::Legislator.by_zipcode(zipcode) 
end
	
def save_thank_you_letters(id, form_letter)
	Dir.mkdir("output") unless Dir.exists? "output"

	filename = "output/thanks_#{id}.html"

	File.open(filename, 'w') do |file|
		file.puts form_letter
	end
end

puts "EventManager initialized."

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.html.erb"
erb_template = ERB.new template_letter

contents.each do |row|
	id = row[0]
	name = row[:first_name]

	zipcode = clean_zipcode(row[:zipcode])

	legislators = legislators_by_zipcode(zipcode)

	form_letter = erb_template.result(binding)
	
	save_thank_you_letters(id, form_letter)
end