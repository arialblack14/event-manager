require "csv"
require_relative 'sunlight-congress'

Sunlight::Congress.api_key = "c09586eb79f04ed79664cdb09c3f6bb9"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, "0")[0..4]
end
	
puts "EventManager initialized!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
	name = row[:first_name]

	zipcode = clean_zipcode(row[:zipcode])
	legislators = Sunlight::Congress::Legislators.by_zipcode(zipcode)

	puts "#{name} #{zipcode} #{legislators}"
end