shops_without_contacts = []
Shop.all.each do |shop|
  shops_without_contacts << shop if shop.contact_items.blank?
end
puts "shops_without_contacts.count: #{shops_without_contacts.count}"